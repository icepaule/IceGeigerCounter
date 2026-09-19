#include <Arduino.h>
#include <WiFi.h>
#include <MQTT.h>
#include <ArduinoJson.h>
#include <SPI.h>
#include <SD.h>
#include "LoRaWan_APP.h"
#include "HT_TinyGPS++.h"
#include "secrets.h"
#include "HT_st7735.h"        // Heltec driver for the on-board 0.96" ST7735 TFT (160x80)

#if !defined(ICEGEIGER_SECRETS_CONFIGURED) || ICEGEIGER_SECRETS_CONFIGURED != 1
#error "Copy secrets.example.h to secrets.h, fill locally and set ICEGEIGER_SECRETS_CONFIGURED to 1"
#endif

// Hardware profile: delivered HITT-Tracker V1.2 (SX1262 + UC6580).
static const char DEVICE_ID[]="icegeiger-v2";
static const int GC_INT_PIN=17;                 // GPIO47 is Boot_Mode on Heltec V1.1-family
static const int VBAT_PIN=1;
static const int SD_SCK=4, SD_MISO=5, SD_MOSI=6, SD_CS=7;
static const uint32_t LOG_MS=10000, LORA_MOBILE_MS=120000, LORA_HOME_MS=900000;
static const float CPM_PER_USVH=151.0f;         // provisional: verify delivered tube before dose interpretation
static const float VBAT_SCALE=4.9f;             // Heltec docs: VBAT = Vbat_Read * 4.9
static const char *LOGFILE="/icegeiger/log.ndjson", *CURSORFILE="/icegeiger/sync.cursor";
volatile uint32_t pulseTotal=0;
uint32_t lastPulseTotal=0, seq=0, lastLog=0, lastWifiTry=0;
uint16_t buckets[6]={0}; uint8_t bucketPos=0;
TinyGPSPlus gps; SPIClass sdSpi(HSPI); WiFiClient net; MQTTClient mqtt(2048);
bool sdOK=false;

uint8_t devEui[8]={0}, appEui[8]={0}, appKey[16]={0};
uint8_t nwkSKey[16]={0}, appSKey[16]={0}; uint32_t devAddr=0;
uint16_t userChannelsMask[6]={0x00FF,0,0,0,0,0};
LoRaMacRegion_t loraWanRegion=ACTIVE_REGION; DeviceClass_t loraWanClass=CLASS_A;
bool overTheAirActivation=true, loraWanAdr=true, isTxConfirmed=false;
uint8_t appPort=2, confirmedNbTrials=1;
uint32_t appTxDutyCycle=LORA_MOBILE_MS;   // required by Heltec LoRaWan_APP (extern in LoRaWan_APP.h)
bool loraEnabled=false;                     // only transmit once an AppKey is provisioned (never TX with all-zero keys / possibly no antenna)

// ---- On-board TFT status screen (Heltec Wireless Tracker: CS38 RST39 DC40 SCLK41 MOSI42, backlight GPIO21, power GPIO3) ----
HT_st7735 tft; uint16_t lastCounts=0; uint32_t lastDraw=0;
static void tftRow(uint8_t row,uint16_t color,const char *s){ char b[24]; snprintf(b,sizeof(b),"%-22s",s); tft.st7735_write_str(0,row*10,b,Font_7x10,color,ST7735_BLACK); }
static void drawStatus(){
  char l[48]; uint32_t cpm=cpm60(); bool fix=gps.location.isValid();
  snprintf(l,sizeof(l),"CPM %lu %.2fuSv/h",(unsigned long)cpm,cpm/CPM_PER_USVH); tftRow(0,ST7735_WHITE,l);
  snprintf(l,sizeof(l),"10s:%u tot:%lu",(unsigned)lastCounts,(unsigned long)pulseTotal); tftRow(1,ST7735_CYAN,l);
  snprintf(l,sizeof(l),fix?"GPS FIX %usat H%.1f":"GPS no fix %usat",(unsigned)(gps.satellites.isValid()?gps.satellites.value():0),gps.hdop.isValid()?gps.hdop.hdop():0.0); tftRow(2,fix?ST7735_GREEN:ST7735_YELLOW,l);
  if(fix) snprintf(l,sizeof(l),"%.4f %.4f",gps.location.lat(),gps.location.lng()); else snprintf(l,sizeof(l),"nmea chars:%lu",(unsigned long)gps.charsProcessed());
  tftRow(3,ST7735_WHITE,l);
  bool w=WiFi.status()==WL_CONNECTED, m=mqtt.connected();
  snprintf(l,sizeof(l),"WiFi:%s MQTT:%s",w?"ok":"--",m?"ok":"--"); tftRow(4,(w&&m)?ST7735_GREEN:ST7735_RED,l);
  const char *lr=!loraEnabled?"off":((deviceState==DEVICE_STATE_INIT||deviceState==DEVICE_STATE_JOIN)?"join":"ok");
  snprintf(l,sizeof(l),"SD:%s LoRa:%s",sdOK?"ok":"--",lr); tftRow(5,ST7735_WHITE,l);
  snprintf(l,sizeof(l),"Bat %.2fV",readBatteryMv()/1000.0f); tftRow(6,ST7735_WHITE,l);
  snprintf(l,sizeof(l),"seq %lu up %lus",(unsigned long)seq,(unsigned long)(millis()/1000)); tftRow(7,ST7735_CYAN,l);
  Serial.printf("[%lus] cpm60=%lu n10=%u tot=%lu gps_fix=%d sats=%u nmea=%lu wifi=%d mqtt=%d sd=%d lora=%s bat=%umV\n",(unsigned long)(millis()/1000),(unsigned long)cpm,(unsigned)lastCounts,(unsigned long)pulseTotal,(int)fix,(unsigned)(gps.satellites.isValid()?gps.satellites.value():0),(unsigned long)gps.charsProcessed(),(int)w,(int)m,(int)sdOK,lr,(unsigned)readBatteryMv());
}

void IRAM_ATTR tubeImpulse(){ pulseTotal++; }
uint32_t unixFromGps(){
  if(!gps.location.isValid()||!gps.date.isValid()||!gps.time.isValid()) return 0;   // without a fix the UC6580 reports a stale RTC date (seen: Jan 2026)
  struct tm t={}; t.tm_year=gps.date.year()-1900; t.tm_mon=gps.date.month()-1; t.tm_mday=gps.date.day();
  t.tm_hour=gps.time.hour(); t.tm_min=gps.time.minute(); t.tm_sec=gps.time.second();
  return (uint32_t)mktime(&t);
}
void feedGps(){ while(Serial1.available()) gps.encode(Serial1.read()); }
uint32_t cpm60(){ uint32_t s=0; for(uint8_t i=0;i<6;i++) s+=buckets[i]; return s; }
uint16_t readBatteryMv(){
  uint32_t sense=analogReadMilliVolts(VBAT_PIN);
  float mv=sense*VBAT_SCALE;
  if(mv<0) mv=0; if(mv>6500) mv=6500;
  return (uint16_t)lroundf(mv);
}
String measurementJson(uint16_t counts, uint32_t cpm){
  StaticJsonDocument<512> d; d["device"]=DEVICE_ID; d["seq"]=seq; d["ts"]=unixFromGps(); d["counts_10s"]=counts; d["cpm_60s"]=cpm;
  d["factor_cpm_per_usvh"]=CPM_PER_USVH; d["usvh"]=cpm/CPM_PER_USVH; d["gps_valid"]=gps.location.isValid();
  if(gps.location.isValid()){ d["lat"]=gps.location.lat(); d["lon"]=gps.location.lng(); }
  d["satellites"]=gps.satellites.isValid()?gps.satellites.value():0; d["hdop"]=gps.hdop.isValid()?gps.hdop.hdop():0; d["battery_mv"]=readBatteryMv();
  String out; serializeJson(d,out); return out;
}
void appendLog(const String &line){ if(!sdOK) return; File f=SD.open(LOGFILE,FILE_APPEND); if(f){ f.println(line); f.close(); } }
uint32_t readCursor(){ if(!sdOK||!SD.exists(CURSORFILE)) return 0; File f=SD.open(CURSORFILE); uint32_t v=f?f.parseInt():0; if(f)f.close(); return v; }
void writeCursor(uint32_t p){ if(!sdOK)return; SD.remove(CURSORFILE); File f=SD.open(CURSORFILE,FILE_WRITE); if(f){ f.print(p); f.close(); } }
void ensureWifi(){ if(WiFi.status()==WL_CONNECTED) return; if(millis()-lastWifiTry<15000)return; lastWifiTry=millis(); WiFi.mode(WIFI_STA); WiFi.begin(WIFI_SSID,WIFI_PASSWORD); }
void ensureMqtt(){ if(WiFi.status()!=WL_CONNECTED||mqtt.connected())return; mqtt.begin(MQTT_HOST,MQTT_PORT,net); if(strlen(MQTT_USER)) mqtt.connect(DEVICE_ID,MQTT_USER,MQTT_PASSWORD); else mqtt.connect(DEVICE_ID); if(mqtt.connected()){ String t=String("icegeiger/")+DEVICE_ID+"/status"; mqtt.publish(t,"online",true,1); } }
void backfill(){
  if(!sdOK||!mqtt.connected())return; File f=SD.open(LOGFILE); if(!f)return; uint32_t pos=readCursor(); if(pos>f.size())pos=0; f.seek(pos); int sent=0;
  while(f.available()&&sent<20){ uint32_t start=f.position(); String line=f.readStringUntil('\n'); line.trim(); uint32_t next=f.position(); if(!line.length()){writeCursor(next);continue;}
    String t=String("icegeiger/")+DEVICE_ID+"/history"; if(!mqtt.publish(t,line,false,1)){ f.seek(start); break; } writeCursor(next); sent++; mqtt.loop();
  } f.close();
}
void packU16(uint8_t *b,int &i,uint16_t v){b[i++]=v>>8;b[i++]=v;}
void packU32(uint8_t *b,int &i,uint32_t v){b[i++]=v>>24;b[i++]=v>>16;b[i++]=v>>8;b[i++]=v;}
void packI32(uint8_t *b,int &i,int32_t v){packU32(b,i,(uint32_t)v);}
static void prepareTxFrame(uint8_t port){
  uint32_t c=cpm60(); int i=0; appData[i++]=1; packU32(appData,i,seq); packU16(appData,i,(uint16_t)min(c,65535UL)); packU16(appData,i,(uint16_t)min((uint32_t)(c/CPM_PER_USVH*1000.0f),65535UL));
  packI32(appData,i,gps.location.isValid()?(int32_t)llround(gps.location.lat()*1e7):0); packI32(appData,i,gps.location.isValid()?(int32_t)llround(gps.location.lng()*1e7):0);
  appData[i++]=gps.satellites.isValid()?min((uint32_t)gps.satellites.value(),255UL):0; appData[i++]=gps.hdop.isValid()?min((int)lround(gps.hdop.hdop()*10),255):0; packU16(appData,i,readBatteryMv()); appDataSize=i;
}
void copyLoRaSecrets(){ memcpy(devEui,ICEGEIGER_DEV_EUI,8); memcpy(appEui,ICEGEIGER_JOIN_EUI,8); memcpy(appKey,ICEGEIGER_APP_KEY,16); }
void serviceLoRa(){
  static uint32_t interval=LORA_MOBILE_MS;
  switch(deviceState){
    case DEVICE_STATE_INIT: LoRaWAN.init(loraWanClass,loraWanRegion); LoRaWAN.setDefaultDR(3); break;
    case DEVICE_STATE_JOIN: LoRaWAN.join(); break;
    case DEVICE_STATE_SEND: prepareTxFrame(appPort); LoRaWAN.send(); deviceState=DEVICE_STATE_CYCLE; break;
    case DEVICE_STATE_CYCLE: interval=(WiFi.status()==WL_CONNECTED)?LORA_HOME_MS:LORA_MOBILE_MS; LoRaWAN.cycle(interval); deviceState=DEVICE_STATE_SLEEP; break;
    case DEVICE_STATE_SLEEP: Mcu.timerhandler(); Radio.IrqProcess(); delay(1); break;
    default: deviceState=DEVICE_STATE_INIT; break;
  }
}
void setup(){
  Serial.begin(115200);
  pinMode(GC_INT_PIN,INPUT); attachInterrupt(digitalPinToInterrupt(GC_INT_PIN),tubeImpulse,FALLING);
  pinMode(VBAT_PIN,INPUT);
  tft.st7735_init(); tft.st7735_fill_screen(ST7735_BLACK); tftRow(0,ST7735_WHITE,"IceGeiger V2 boot");   // TFT init also sets GPIO3 (shared Vext) HIGH
  Serial1.begin(115200,SERIAL_8N1,33,34); pinMode(3,OUTPUT); digitalWrite(3,HIGH);
  sdSpi.begin(SD_SCK,SD_MISO,SD_MOSI,SD_CS); sdOK=SD.begin(SD_CS,sdSpi,8000000); if(sdOK&&!SD.exists("/icegeiger"))SD.mkdir("/icegeiger");
  copyLoRaSecrets(); for(uint8_t i=0;i<16;i++) if(appKey[i]) loraEnabled=true;
  Mcu.begin(HELTEC_BOARD,SLOW_CLK_TPYE); ensureWifi();
}
void loop(){
  feedGps(); ensureWifi(); ensureMqtt(); if(mqtt.connected())mqtt.loop(); if(loraEnabled) serviceLoRa();
  if(millis()-lastLog>=LOG_MS){ lastLog+=LOG_MS; uint32_t now=pulseTotal; uint16_t counts=(uint16_t)min(now-lastPulseTotal,65535UL); lastPulseTotal=now; buckets[bucketPos]=counts; lastCounts=counts; bucketPos=(bucketPos+1)%6; seq++;
    String j=measurementJson(counts,cpm60()); appendLog(j); if(mqtt.connected()){ String t=String("icegeiger/")+DEVICE_ID+"/live"; mqtt.publish(t,j,false,1); backfill(); }
  }
  if(millis()-lastDraw>=1000){ lastDraw=millis(); drawStatus(); }
  delay(1);
}
