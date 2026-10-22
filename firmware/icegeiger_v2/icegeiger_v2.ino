#include <Arduino.h>
#include <WiFi.h>
#include <MQTT.h>
#include <ArduinoJson.h>
#include <SPI.h>
#include <SD.h>
#include <RadioLib.h>   // replaces Heltec's own LoRaWan_APP: that vendor library crashes the radio's
                        // own interrupt handling during transmit (Interrupt WDT panic, confirmed via
                        // addr2line even with TFT redraw fully disabled - see docs/v2/05-lorawan-chirpstack.md
                        // section 10.5). RadioLib is actively maintained and doesn't share that bug.
#include "HT_TinyGPS++.h"
#include "secrets.h"
#include "HT_st7735.h"        // Heltec driver for the on-board 0.96" ST7735 TFT (160x80)

// 22.10.2026: RadioLib validated stable (6+ consecutive uplinks, ChirpStack MIC-verified, no crash) -
// on by default now. To disable (the #ifdef below only checks existence, not value): comment this out.
#define ICEGEIGER_ENABLE_LORA
#ifndef ICEGEIGER_LORAWAN_ABP
#define ICEGEIGER_LORAWAN_ABP 0   // 1 = ABP (uplink-only tests against a single-channel gateway), 0 = OTAA
#endif
#if !defined(ICEGEIGER_SECRETS_CONFIGURED) || ICEGEIGER_SECRETS_CONFIGURED != 1
#error "Copy secrets.example.h to secrets.h, fill locally and set ICEGEIGER_SECRETS_CONFIGURED to 1"
#endif

// Hardware profile: delivered HITT-Tracker V1.2 (SX1262 + UC6580).
static const char DEVICE_ID[]="icegeiger-v2";
static const int GC_INT_PIN=7;                  // real wiring (20.10.2026): wired to GPIO7, not GPIO17 as first planned;
                                                 // moved SD_CS off GPIO7 below to avoid a pin clash (SD stays unused for now anyway)
static const int VBAT_PIN=1;
static const int SD_SCK=4, SD_MISO=5, SD_MOSI=6, SD_CS=15;   // was 7 - freed up for GC_INT_PIN, GPIO15 is otherwise unused (U0RTS/XTAL_32K_P, not wired)
// SX1262 wiring (Heltec board-config.h, WIRELESS_TRACKER): separate SPI bus from the TFT's HSPI.
static const int LORA_NSS=8, LORA_DIO1=14, LORA_RESET=12, LORA_BUSY=13, LORA_SCK=9, LORA_MISO=11, LORA_MOSI=10;
#ifdef ICEGEIGER_LORA_TEST_INTERVAL_MS     // test builds only: shorter uplink interval (stay below 1 % duty cycle)
static const uint32_t LOG_MS=10000, LORA_MOBILE_MS=ICEGEIGER_LORA_TEST_INTERVAL_MS, LORA_HOME_MS=ICEGEIGER_LORA_TEST_INTERVAL_MS;
#else
static const uint32_t LOG_MS=10000, LORA_MOBILE_MS=120000, LORA_HOME_MS=900000;
#endif
static const float CPM_PER_USVH=151.0f;         // provisional: verify delivered tube before dose interpretation
static const float VBAT_SCALE=4.9f;             // Heltec docs: VBAT = Vbat_Read * 4.9
static const char *LOGFILE="/icegeiger/log.ndjson", *CURSORFILE="/icegeiger/sync.cursor";
volatile uint32_t pulseTotal=0;
uint32_t lastPulseTotal=0, seq=0, lastLog=0, lastWifiTry=0;
uint8_t wifiRetryCount=0;   // exponential backoff: the Bad!IoT link is intermittently flaky here and
                            // retrying every ~20-35s generated enough WiFi-interrupt churn to trip a
                            // Core0 IDLE task stack-canary watchdog (18.10.2026) - back off harder.
uint16_t buckets[6]={0}; uint8_t bucketPos=0;
TinyGPSPlus gps; SPIClass sdSpi(HSPI); WiFiClient net; MQTTClient mqtt(2048);
bool sdOK=false;

// ABP session keys. LoRaWAN 1.0.x only has a single NwkSKey; RadioLib's 1.1-shaped API wants it
// split into FNwkSIntKey/SNwkSIntKey/NwkSEncKey - the standard 1.0.x->1.1 compat mapping is to set
// all three to the same NwkSKey value (see copyLoRaSecrets()).
uint8_t nwkSEncKey[16]={0}, appSKey[16]={0}; uint32_t devAddr=0;
uint8_t appPort=2;
bool loraEnabled=false;                     // only transmit once a DevAddr is provisioned (never TX with all-zero keys / possibly no antenna)
uint32_t lastTxMillis=0;

// Single fixed channel matching the ChirpStack test setup's T-Beam single-channel gateway
// (868.1MHz/SF9/125kHz = DR3, see firmware/tbeam_singlechannel_gateway). RadioLib's stock EU868
// band hops across 3 default channels; that gateway only ever listens on one, so uplinks would
// mostly be missed. This is an exact copy of RadioLib's built-in EU868 (LoRaWANBands.cpp) with
// txFreqs trimmed to channel 0 only, locked to DR3 - revisit once a real multi-channel OTAA
// gateway is in use (see docs/v2/05-lorawan-chirpstack.md section 10.5's decision note).
const LoRaWANBand_t EU868_SINGLE = {
  .bandNum = BandEU868,
  .bandType = RADIOLIB_LORAWAN_BAND_DYNAMIC,
  .freqMin = 8630000,
  .freqMax = 8700000,
  .payloadLenMax = {  51,  51,  51, 115, 242, 242, 242, 242,  50, 115,  50, 115,   0,   0,   0 },
  .powerMax = 16,
  .powerNumSteps = 7,
  .dutyCycle = 36000,
  .dwellTimeUp = 0,
  .dwellTimeDn = 0,
  .txParamSupported = false,
  .txFreqs = {
    { .idx = 0, .freq = 8681000, .drMin = 3, .drMax = 3, .dr = 3 },
    RADIOLIB_LORAWAN_CHANNEL_NONE,
    RADIOLIB_LORAWAN_CHANNEL_NONE,
  },
  .numTxSpans = 0,
  .txSpans = {
    RADIOLIB_LORAWAN_CHANNEL_SPAN_NONE,
    RADIOLIB_LORAWAN_CHANNEL_SPAN_NONE
  },
  .rx1Span = RADIOLIB_LORAWAN_CHANNEL_SPAN_NONE,
  .rx1DrTable = {
    {    0,    0,    0,    0,    0,    0, 0x0F, 0x0F },
    {    1,    0,    0,    0,    0,    0, 0x0F, 0x0F },
    {    2,    1,    0,    0,    0,    0, 0x0F, 0x0F },
    {    3,    2,    1,    0,    0,    0, 0x0F, 0x0F },
    {    4,    3,    2,    1,    0,    0, 0x0F, 0x0F },
    {    5,    4,    3,    2,    1,    0, 0x0F, 0x0F },
    {    6,    5,    4,    3,    2,    1, 0x0F, 0x0F },
    {    7,    6,    5,    4,    3,    2, 0x0F, 0x0F },
    {    1,    0,    0,    0,    0,    0, 0x0F, 0x0F },
    {    2,    1,    0,    0,    0,    0, 0x0F, 0x0F },
    {    1,    0,    0,    0,    0,    0, 0x0F, 0x0F },
    {    2,    1,    0,    0,    0,    0, 0x0F, 0x0F },
    { 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F },
    { 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F },
    { 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F }
  },
  .rx2 = { .idx = 0, .freq = 8695250, .drMin = 0, .drMax = 7, .dr = 0 },
  .txWoR = {
    { .idx = 0, .freq = 8651000, .drMin = 3, .drMax = 3, .dr = 3 },
    { .idx = 1, .freq = 8655000, .drMin = 3, .drMax = 3, .dr = 3 }
  },
  .txAck = {
    { .idx = 0, .freq = 8653000, .drMin = 3, .drMax = 3, .dr = 3 },
    { .idx = 1, .freq = 8659000, .drMin = 3, .drMax = 3, .dr = 3 }
  },
  .dataRates = {
    { .modem = RADIOLIB_MODEM_LORA,   .dr = {.lora = {12, 125, 5}}, .pc = {.lora = {8, false, true, true}}},
    { .modem = RADIOLIB_MODEM_LORA,   .dr = {.lora = {11, 125, 5}}, .pc = {.lora = {8, false, true, true}}},
    { .modem = RADIOLIB_MODEM_LORA,   .dr = {.lora = {10, 125, 5}}, .pc = {.lora = {8, false, true, false}}},
    { .modem = RADIOLIB_MODEM_LORA,   .dr = {.lora = { 9, 125, 5}}, .pc = {.lora = {8, false, true, false}}},
    { .modem = RADIOLIB_MODEM_LORA,   .dr = {.lora = { 8, 125, 5}}, .pc = {.lora = {8, false, true, false}}},
    { .modem = RADIOLIB_MODEM_LORA,   .dr = {.lora = { 7, 125, 5}}, .pc = {.lora = {8, false, true, false}}},
    { .modem = RADIOLIB_MODEM_LORA,   .dr = {.lora = { 7, 250, 5}}, .pc = {.lora = {8, false, true, false}}},
    { .modem = RADIOLIB_MODEM_FSK,    .dr = {.fsk  = {50, 25}},     .pc = {.fsk  = {40, 24, 2}}},
    { .modem = RADIOLIB_MODEM_LRFHSS, .dr = {.lrFhss = {2, 3, 1}},  .pc = {.lrFhss = {3}}},
    { .modem = RADIOLIB_MODEM_LRFHSS, .dr = {.lrFhss = {2, 1, 1}},  .pc = {.lrFhss = {2}}},
    { .modem = RADIOLIB_MODEM_LRFHSS, .dr = {.lrFhss = {4, 3, 1}},  .pc = {.lrFhss = {3}}},
    { .modem = RADIOLIB_MODEM_LRFHSS, .dr = {.lrFhss = {4, 1, 1}},  .pc = {.lrFhss = {2}}},
    RADIOLIB_DATARATE_NONE,
    RADIOLIB_DATARATE_NONE,
    RADIOLIB_DATARATE_NONE
  }
};
SPIClass loraSpi(FSPI);
SX1262 radio = new Module(LORA_NSS, LORA_DIO1, LORA_RESET, LORA_BUSY, loraSpi);
LoRaWANNode node(&radio, &EU868_SINGLE, 0);

// ---- On-board TFT status screen (Heltec Wireless Tracker: CS38 RST39 DC40 SCLK41 MOSI42, backlight GPIO21, power GPIO3) ----
HT_st7735 tft; uint16_t lastCounts=0; uint32_t lastDraw=0;
static void tftRow(uint8_t row,uint16_t color,const char *s){ char b[24]; snprintf(b,sizeof(b),"%-22s",s); tft.st7735_write_str(0,row*10,b,Font_7x10,color,ST7735_BLACK); }
static void drawStatus(){
  char l[48]; uint32_t cpm=cpm60(); bool fix=gps.location.isValid();
  snprintf(l,sizeof(l),"CPM %lu %.2fuSv/h",(unsigned long)cpm,cpm/CPM_PER_USVH); tftRow(0,ST7735_WHITE,l);
  snprintf(l,sizeof(l),"10s:%u tot:%lu",(unsigned)lastCounts,(unsigned long)pulseTotal); tftRow(1,ST7735_CYAN,l);
  snprintf(l,sizeof(l),fix?"GPS FIX %usat H%.1f":"GPS no fix %usat",(unsigned)(gps.satellites.isValid()?gps.satellites.value():0),gps.hdop.isValid()?gps.hdop.hdop():0.0); tftRow(2,fix?ST7735_GREEN:ST7735_YELLOW,l);
  if(fix) snprintf(l,sizeof(l),"%.4f %.4f",gps.location.lat(),gps.location.lng()); else snprintf(l,sizeof(l),"nmea ok:%lu bad:%lu",(unsigned long)gps.passedChecksum(),(unsigned long)gps.failedChecksum());
  tftRow(3,ST7735_WHITE,l);
  bool w=WiFi.status()==WL_CONNECTED, m=mqtt.connected();
  snprintf(l,sizeof(l),"WiFi:%s MQTT:%s",w?"ok":"--",m?"ok":"--"); tftRow(4,(w&&m)?ST7735_GREEN:ST7735_RED,l);
  const char *lr=!loraEnabled?"off":(node.isActivated()?"ok":"join");
  snprintf(l,sizeof(l),"SD:%s LoRa:%s",sdOK?"ok":"--",lr); tftRow(5,ST7735_WHITE,l);
  snprintf(l,sizeof(l),"Bat %.2fV",readBatteryMv()/1000.0f); tftRow(6,ST7735_WHITE,l);
  snprintf(l,sizeof(l),"seq %lu up %lus",(unsigned long)seq,(unsigned long)(millis()/1000)); tftRow(7,ST7735_CYAN,l);
  Serial.printf("[%lus] cpm60=%lu n10=%u tot=%lu gps_fix=%d sats=%u chars=%lu ok=%lu bad=%lu wifi=%d(st%d) mqtt=%d sd=%d lora=%s bat=%umV\n",(unsigned long)(millis()/1000),(unsigned long)cpm,(unsigned)lastCounts,(unsigned long)pulseTotal,(int)fix,(unsigned)(gps.satellites.isValid()?gps.satellites.value():0),(unsigned long)gps.charsProcessed(),(unsigned long)gps.passedChecksum(),(unsigned long)gps.failedChecksum(),(int)w,(int)WiFi.status(),(int)m,(int)sdOK,lr,(unsigned)readBatteryMv());
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
void ensureWifi(){
  // bug found 18.10.2026: re-issuing WiFi.begin() every 15s regardless of whether the previous
  // association attempt had already finished caused "wifi:sta is connecting, cannot set config"
  // and the connection never completed. Fix: explicitly tear down any in-flight attempt first.
  if(WiFi.status()==WL_CONNECTED){ wifiRetryCount=0; return; }
  uint32_t backoff=35000UL<<min((int)wifiRetryCount,4);   // 35s,70s,140s,280s,560s cap
  if(millis()-lastWifiTry<backoff) return;
  lastWifiTry=millis();
  if(wifiRetryCount<200) wifiRetryCount++;
  Serial.printf("wifi: retry #%u (status=%d, next backoff %lus)\n",wifiRetryCount,(int)WiFi.status(),(unsigned long)(backoff/1000));
  // scan+BSSID-pin (tested 18.10.2026) did not help and adds radio time to the critical path;
  // removed again. Root cause of the intermittent "reason=2/201/36" failures against the Bad!IoT
  // multi-AP mesh looks environmental/RF, not something this retry logic can paper over - see
  // docs/v2/13-validation-status.md.
  WiFi.disconnect(true);
  delay(100);
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);
  // found 18.10.2026: crashes (Core0 Interrupt WDT / IDLE0 stack-canary) kept happening ~40-70s
  // after the FIRST connect attempt regardless of our own outer retry backoff above. Cause: once
  // WiFi.begin() is issued, ESP-IDF's own internal auto-reconnect keeps retrying many times per
  // second on its own (visible as a burst of "disconnected reason=2" events) for as long as the
  // link stays down - that sustained internal storm, not our app-level cadence, is what exhausts
  // the interrupt/idle-task time budget. Disabling it lets only OUR slower cadence drive retries.
  WiFi.setAutoReconnect(false);
  WiFi.begin(WIFI_SSID,WIFI_PASSWORD);
}
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
uint8_t txPayload[32]={0}, txPayloadSize=0;
static void prepareTxFrame(uint8_t port){
  uint32_t c=cpm60(); int i=0; txPayload[i++]=1; packU32(txPayload,i,seq); packU16(txPayload,i,(uint16_t)min(c,65535UL)); packU16(txPayload,i,(uint16_t)min((uint32_t)(c/CPM_PER_USVH*1000.0f),65535UL));
  packI32(txPayload,i,gps.location.isValid()?(int32_t)llround(gps.location.lat()*1e7):0); packI32(txPayload,i,gps.location.isValid()?(int32_t)llround(gps.location.lng()*1e7):0);
  txPayload[i++]=gps.satellites.isValid()?min((uint32_t)gps.satellites.value(),255UL):0; txPayload[i++]=gps.hdop.isValid()?min((int)lround(gps.hdop.hdop()*10),255):0; packU16(txPayload,i,readBatteryMv()); txPayloadSize=i;
}
void copyLoRaSecrets(){
#if ICEGEIGER_LORAWAN_ABP
  // ABP only for now (see EU868_SINGLE above): fixed single channel (868.1 MHz), fixed DR3 (SF9/125 kHz).
  // LoRaWAN 1.0.x has a single NwkSKey. RadioLib's beginABP() docs: pass NULL for fNwkSIntKey/
  // sNwkSIntKey to mean "1.0.x device" - passing the same key into all three (tried first) makes
  // it compute MIC the 1.1 way instead, which ChirpStack (set to 1.0.x for this device) then
  // rejects as "no valid MIC" even though the DevAddr decodes fine.
  devAddr=ICEGEIGER_DEV_ADDR;
  memcpy(nwkSEncKey,ICEGEIGER_NWK_S_KEY,16);
  memcpy(appSKey,ICEGEIGER_APP_S_KEY,16);
#endif
}
void serviceLoRa(){
  // RadioLib's LoRaWANNode::sendReceive() is a single blocking call (CSMA/duty-cycle wait, TX,
  // then it waits through the RX1/RX2 windows) - no separate per-loop IRQ-servicing state machine
  // needed, unlike the old vendor library.
  uint32_t interval=(WiFi.status()==WL_CONNECTED)?LORA_HOME_MS:LORA_MOBILE_MS;
  if(lastTxMillis!=0 && millis()-lastTxMillis<interval) return;
  lastTxMillis=millis();
  prepareTxFrame(appPort);
  int16_t state=node.sendReceive(txPayload,txPayloadSize,appPort);
  Serial.printf("lora: sendReceive state=%d\n",(int)state);
}
void onWifiEvent(WiFiEvent_t ev, WiFiEventInfo_t info){
  // found 18.10.2026: during a fast AUTH_EXPIRE retry burst this fired many times per second;
  // Serial.printf() on every single event flooded the native USB-CDC TX path and triggered a
  // Core0 Interrupt WDT panic (stuck in the WiFi FIQ handler's queue_send_from_isr, waiting on a
  // critical section while something - almost certainly this logging - held it too long). Throttled.
  static uint32_t lastEvLog=0;
  if(ev==ARDUINO_EVENT_WIFI_STA_DISCONNECTED){ if(millis()-lastEvLog>2000){ lastEvLog=millis(); Serial.printf("wifi: disconnected reason=%d (t+%lums since retry)\n",(int)info.wifi_sta_disconnected.reason,(unsigned long)(millis()-lastWifiTry)); } }
  else if(ev==ARDUINO_EVENT_WIFI_STA_CONNECTED) Serial.printf("wifi: associated (L2 ok) bssid=%s ch=%d t+%lums\n",WiFi.BSSIDstr().c_str(),(int)WiFi.channel(),(unsigned long)(millis()-lastWifiTry));
  else if(ev==ARDUINO_EVENT_WIFI_STA_GOT_IP) Serial.printf("wifi: got ip %s rssi=%d t+%lums\n",WiFi.localIP().toString().c_str(),WiFi.RSSI(),(unsigned long)(millis()-lastWifiTry));
}
void setup(){
  Serial.begin(115200);
  delay(6000);   // debug request 18.10.2026: give the USB-CDC host side time to attach before the scan dump
                 // (2000ms was not enough - native USB-CDC drops early output if nobody is reading yet)
  WiFi.mode(WIFI_STA);
  Serial.println("wifi: boot-time scan starting...");
  { int n=WiFi.scanNetworks();
    Serial.printf("wifi: scan found %d networks\n",n);
    for(int i=0;i<n;i++){
      Serial.printf("  ssid=\"%s\" bssid=%s rssi=%d ch=%d enc=%d\n",
        WiFi.SSID(i).c_str(),WiFi.BSSIDstr(i).c_str(),WiFi.RSSI(i),WiFi.channel(i),(int)WiFi.encryptionType(i));
    }
    WiFi.scanDelete();
  }
  WiFi.onEvent(onWifiEvent);
  pinMode(GC_INT_PIN,INPUT); attachInterrupt(digitalPinToInterrupt(GC_INT_PIN),tubeImpulse,FALLING);
  pinMode(VBAT_PIN,INPUT);
  tft.st7735_init(); tft.st7735_fill_screen(ST7735_BLACK); tftRow(0,ST7735_WHITE,"IceGeiger V2 boot");   // TFT init also sets GPIO3 (shared Vext) HIGH
  Serial1.begin(115200,SERIAL_8N1,33,34); pinMode(3,OUTPUT); digitalWrite(3,HIGH);
#ifdef ICEGEIGER_ENABLE_SD   // SD card not wired up yet; its SPI (HSPI) would also be touched by the TFT driver, so stay off until it's actually needed
  sdSpi.begin(SD_SCK,SD_MISO,SD_MOSI,SD_CS); sdOK=SD.begin(SD_CS,sdSpi,8000000); if(sdOK&&!SD.exists("/icegeiger"))SD.mkdir("/icegeiger");
#endif
  copyLoRaSecrets();
#ifdef ICEGEIGER_ENABLE_LORA   // 22.10.2026: swapped the buggy Heltec LoRaWan_APP for RadioLib
                               // (see the #include above) - ABP only for now, matching the
                               // single-channel ChirpStack test gateway (EU868_SINGLE above).
  loraEnabled=(devAddr!=0);
  if(loraEnabled){
    loraSpi.begin(LORA_SCK,LORA_MISO,LORA_MOSI,LORA_NSS);
    int st=radio.begin(868.1,125.0,9,5,RADIOLIB_SX126X_SYNC_WORD_PUBLIC,10,8,1.8,false);   // freq/SF/BW/sync don't matter much here - LoRaWANNode retunes per-TX from EU868_SINGLE; TCXO 1.8V/DIO2-as-RF-switch match Heltec's own sx1262-board.c SX126xInit()
    Serial.printf("lora: radio.begin state=%d\n",(int)st);
    if(st==RADIOLIB_ERR_NONE){
      node.beginABP(devAddr,nullptr,nullptr,nwkSEncKey,appSKey);
      st=node.activateABP();
      Serial.printf("lora: activateABP state=%d\n",(int)st);
      node.setADR(false);
      node.setDatarate(3);
    } else loraEnabled=false;
  }
#endif
  ensureWifi();
}
void loop(){
  feedGps(); ensureWifi(); ensureMqtt(); if(mqtt.connected())mqtt.loop(); if(loraEnabled) serviceLoRa();
  if(millis()-lastLog>=LOG_MS){ lastLog+=LOG_MS; uint32_t now=pulseTotal; uint16_t counts=(uint16_t)min(now-lastPulseTotal,65535UL); lastPulseTotal=now; buckets[bucketPos]=counts; lastCounts=counts; bucketPos=(bucketPos+1)%6; seq++;
    String j=measurementJson(counts,cpm60()); appendLog(j); if(mqtt.connected()){ String t=String("icegeiger/")+DEVICE_ID+"/live"; mqtt.publish(t,j,false,1); backfill(); }
  }
  // 22.10.2026: RadioLib's sendReceive() is a single blocking call (no background IRQ-driven state
  // machine to starve like the old vendor library had), so the TFT-vs-radio interrupt conflict that
  // forced disabling the display while LoRaWAN was active likely doesn't apply here. Kept off for
  // now anyway during this first RadioLib validation pass, to keep the crash/no-crash result clean;
  // revisit once sendReceive() has been confirmed stable over a longer soak.
  if(!loraEnabled && millis()-lastDraw>=3000){ lastDraw=millis(); drawStatus(); }
  delay(1);
}
