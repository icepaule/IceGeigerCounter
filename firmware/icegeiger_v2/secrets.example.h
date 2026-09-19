#pragma once
// Copy to secrets.h, fill locally, NEVER commit secrets.h.
#define ICEGEIGER_SECRETS_CONFIGURED 0
static const char WIFI_SSID[] = "CHANGE_ME";
static const char WIFI_PASSWORD[] = "CHANGE_ME";
static const char MQTT_HOST[] = "CHANGE_ME";
static const uint16_t MQTT_PORT = 1883;
static const char MQTT_USER[] = "CHANGE_ME";
static const char MQTT_PASSWORD[] = "CHANGE_ME";
static const uint8_t ICEGEIGER_DEV_EUI[8] = {0,0,0,0,0,0,0,0};
static const uint8_t ICEGEIGER_JOIN_EUI[8] = {0,0,0,0,0,0,0,0};
static const uint8_t ICEGEIGER_APP_KEY[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
// LoRaWAN activation. Default is OTAA (fill DEV_EUI / JOIN_EUI / APP_KEY above).
// ABP is only for uplink tests against a single-channel gateway: set ICEGEIGER_LORAWAN_ABP to 1 and fill the three values below.
#define ICEGEIGER_LORAWAN_ABP 0
static const uint32_t ICEGEIGER_DEV_ADDR = 0;
static const uint8_t ICEGEIGER_NWK_S_KEY[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static const uint8_t ICEGEIGER_APP_S_KEY[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
// Optional, test builds only (milliseconds between LoRaWAN uplinks; keep airtime below 1 % duty cycle):
// #define ICEGEIGER_LORA_TEST_INTERVAL_MS 60000
