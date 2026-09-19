// IceGeiger test gateway: LILYGO T-Beam as SINGLE-CHANNEL, UPLINK-ONLY LoRa receiver.
// Receives on 868.1 MHz / SF9 / 125 kHz and forwards frames as Semtech UDP "PUSH_DATA" to the
// ChirpStack Gateway Bridge (UDP 1700). No downlinks: use ABP devices, not OTAA. Not a LoRaWAN-compliant gateway.
// Boards: T-Beam v1.x (AXP192) or v1.2 (AXP2101); radio SX1276 or SX1262 is detected at boot.
#include <Arduino.h>
#include <WiFi.h>
#include <WiFiUdp.h>
#include <Wire.h>
#include <SPI.h>
#include <RadioLib.h>
#include <XPowersLib.h>
#include <mbedtls/base64.h>
#include <esp_mac.h>
#include "secrets.h"

#define I2C_SDA 21
#define I2C_SCL 22
#define LORA_SCK 5
#define LORA_MISO 19
#define LORA_MOSI 27
#define LORA_CS 18
#define LORA_RST 23
#define LORA_DIO0 26      // SX1276 IRQ
#define LORA_DIO1 33      // SX1262 IRQ (SX1276: DIO1 unused here)
#define LORA_BUSY 32      // SX1262 BUSY

static const float FREQ_MHZ = 868.1f, BW_KHZ = 125.0f;
static const double FREQ_MHZ_JSON = 868.1;   // float 868.1f would print as 868.099976 and ChirpStack finds no matching channel
static const uint8_t SF = 9, CR_DENOM = 5;   // DR3 = SF9/125 kHz, coding rate 4/5
static const uint32_t PULL_MS = 5000, STAT_MS = 30000;

XPowersAXP192 pmu192; XPowersAXP2101 pmu2101;
SX1276 *r76 = nullptr; SX1262 *r62 = nullptr;
WiFiUDP udp; IPAddress bridgeIp;
uint8_t gwEui[8]; uint16_t token = 1;
volatile bool rxFlag = false;
uint32_t rxnb = 0, rxok = 0, rxfw = 0, lastPull = 0, lastStat = 0, lastWifiTry = 0;

void IRAM_ATTR onRx() { rxFlag = true; }

bool initPower() {
  Wire.begin(I2C_SDA, I2C_SCL);
  if (pmu2101.begin(Wire, AXP2101_SLAVE_ADDRESS, I2C_SDA, I2C_SCL)) {
    pmu2101.setALDO2Voltage(3300); pmu2101.enableALDO2();   // LoRa
    Serial.println("PMU: AXP2101 (T-Beam v1.2), ALDO2=3.3V LoRa"); return true;
  }
  if (pmu192.begin(Wire, AXP192_SLAVE_ADDRESS, I2C_SDA, I2C_SCL)) {
    pmu192.setLDO2Voltage(3300); pmu192.enableLDO2();       // LoRa
    pmu192.disableLDO3();                                                          // GPS off
    Serial.println("PMU: AXP192 (T-Beam v1.0/1.1), LDO2=3.3V LoRa"); return true;
  }
  Serial.println("PMU: none found (continuing, LoRa may be unpowered)"); return false;
}

bool initRadio() {
  SPI.begin(LORA_SCK, LORA_MISO, LORA_MOSI, LORA_CS);
  r76 = new SX1276(new Module(LORA_CS, LORA_DIO0, LORA_RST, LORA_DIO1));
  int s = r76->begin(FREQ_MHZ, BW_KHZ, SF, CR_DENOM, 0x34, 10, 8, 0);
  if (s == RADIOLIB_ERR_NONE) { r76->setPacketReceivedAction(onRx); r76->startReceive(); Serial.println("Radio: SX1276 ok"); return true; }
  Serial.printf("SX1276 init failed (%d), trying SX1262\n", s);
  delete r76; r76 = nullptr;
  r62 = new SX1262(new Module(LORA_CS, LORA_DIO1, LORA_RST, LORA_BUSY));
  s = r62->begin(FREQ_MHZ, BW_KHZ, SF, CR_DENOM, 0x34, 10, 8, 0.0f, false);
  if (s == RADIOLIB_ERR_NONE) { r62->setDio2AsRfSwitch(true); r62->setPacketReceivedAction(onRx); r62->startReceive(); Serial.println("Radio: SX1262 ok"); return true; }
  Serial.printf("SX1262 init failed (%d)\n", s); return false;
}

void ensureWifi() {
  if (WiFi.status() == WL_CONNECTED || millis() - lastWifiTry < 15000) return;
  lastWifiTry = millis(); WiFi.mode(WIFI_STA); WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
}

void sendPacket(uint8_t type, const char *json) {   // Semtech protocol v2: version, token(2), type, gateway EUI(8), payload
  uint8_t buf[512]; uint16_t t = token++;
  buf[0] = 2; buf[1] = t >> 8; buf[2] = t & 0xFF; buf[3] = type; memcpy(buf + 4, gwEui, 8);
  size_t n = 12;
  if (json) { size_t l = strlen(json); if (l > sizeof(buf) - 12) return; memcpy(buf + 12, json, l); n += l; }
  udp.beginPacket(bridgeIp, GW_BRIDGE_PORT); udp.write(buf, n); udp.endPacket();
}

void handleRx() {
  rxFlag = false; rxnb++;
  uint8_t data[256]; int len = r76 ? r76->getPacketLength() : r62->getPacketLength();
  if (len <= 0 || len > (int)sizeof(data)) { if (r76) r76->startReceive(); else r62->startReceive(); return; }
  int st = r76 ? r76->readData(data, len) : r62->readData(data, len);
  float rssi = r76 ? r76->getRSSI() : r62->getRSSI(), snr = r76 ? r76->getSNR() : r62->getSNR();
  if (r76) r76->startReceive(); else r62->startReceive();
  if (st != RADIOLIB_ERR_NONE) { Serial.printf("rx error %d (len %d)\n", st, len); return; }
  rxok++;
  char b64[400]; size_t ol = 0; mbedtls_base64_encode((unsigned char *)b64, sizeof(b64) - 1, &ol, data, len); b64[ol] = 0;
  char json[700];
  snprintf(json, sizeof(json),
    "{\"rxpk\":[{\"tmst\":%lu,\"chan\":0,\"rfch\":0,\"freq\":%.6f,\"stat\":1,\"modu\":\"LORA\",\"datr\":\"SF%uBW125\",\"codr\":\"4/5\",\"lsnr\":%.1f,\"rssi\":%d,\"size\":%d,\"data\":\"%s\"}]}",
    (unsigned long)micros(), FREQ_MHZ_JSON, SF, snr, (int)rssi, len, b64);
  if (WiFi.status() == WL_CONNECTED) { sendPacket(0x00, json); rxfw++; }
  Serial.printf("rx %d bytes rssi=%.0f snr=%.1f fwd=%d first=0x%02X\n", len, rssi, snr, WiFi.status() == WL_CONNECTED, data[0]);
}

void setup() {
  Serial.begin(115200); delay(1500);
  Serial.println("IceGeiger T-Beam single-channel gateway");
  initPower(); bool radioOk = initRadio();
  ensureWifi();
  uint8_t mac[6]; esp_read_mac(mac, ESP_MAC_WIFI_STA);   // WiFi.macAddress() returns zeros before the WiFi stack is up
  gwEui[0] = mac[0]; gwEui[1] = mac[1]; gwEui[2] = mac[2]; gwEui[3] = 0xFF; gwEui[4] = 0xFE; gwEui[5] = mac[3]; gwEui[6] = mac[4]; gwEui[7] = mac[5];
  Serial.printf("Gateway EUI: %02x%02x%02x%02x%02x%02x%02x%02x radio=%d\n", gwEui[0], gwEui[1], gwEui[2], gwEui[3], gwEui[4], gwEui[5], gwEui[6], gwEui[7], radioOk);
  bridgeIp.fromString(GW_BRIDGE_HOST);
  configTime(0, 0, NTP_SERVER);
}

void loop() {
  ensureWifi();
  if (rxFlag) handleRx();
  if (WiFi.status() == WL_CONNECTED) {
    if (millis() - lastPull > PULL_MS) { lastPull = millis(); sendPacket(0x02, nullptr); }   // PULL_DATA keep-alive
    if (millis() - lastStat > STAT_MS) {
      lastStat = millis(); char json[200], ts[32] = "";
      time_t now = time(nullptr);
      if (now > 1700000000) { struct tm tmv; gmtime_r(&now, &tmv); strftime(ts, sizeof(ts), "\"time\":\"%Y-%m-%d %H:%M:%S GMT\",", &tmv); }
      snprintf(json, sizeof(json), "{\"stat\":{%s\"rxnb\":%lu,\"rxok\":%lu,\"rxfw\":%lu,\"ackr\":100.0,\"dwnb\":0,\"txnb\":0}}", ts, (unsigned long)rxnb, (unsigned long)rxok, (unsigned long)rxfw);
      sendPacket(0x00, json);
      Serial.printf("[%lus] wifi=%d ip=%s rxnb=%lu rxok=%lu\n", millis() / 1000, WiFi.status() == WL_CONNECTED, WiFi.localIP().toString().c_str(), (unsigned long)rxnb, (unsigned long)rxok);
    }
    int n = udp.parsePacket(); if (n > 0) { uint8_t tmp[64]; udp.read(tmp, min(n, 64)); }      // drop PUSH_ACK / PULL_ACK
  }
  delay(1);
}
