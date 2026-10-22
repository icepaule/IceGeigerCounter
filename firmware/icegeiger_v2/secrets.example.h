#pragma once
// Copy to secrets.h, fill locally, NEVER commit secrets.h.
#define ICEGEIGER_SECRETS_CONFIGURED 0
static const char WIFI_SSID[] = "CHANGE_ME";
static const char WIFI_PASSWORD[] = "CHANGE_ME";
static const char MQTT_HOST[] = "CHANGE_ME";
static const uint16_t MQTT_PORT = 1883;
static const char MQTT_USER[] = "CHANGE_ME";
static const char MQTT_PASSWORD[] = "CHANGE_ME";
// 22.10.2026: the RadioLib port (replacing Heltec's crash-prone LoRaWan_APP) only wires up ABP so
// far, matching the single-channel ChirpStack test gateway in use. DEV_EUI/JOIN_EUI/APP_KEY below
// are unused until OTAA is ported too (needs a real multi-channel gateway to test against - see
// docs/v2/05-lorawan-chirpstack.md section 10.5's decision note).
static const uint8_t ICEGEIGER_DEV_EUI[8] = {0,0,0,0,0,0,0,0};
static const uint8_t ICEGEIGER_JOIN_EUI[8] = {0,0,0,0,0,0,0,0};
static const uint8_t ICEGEIGER_APP_KEY[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
// LoRaWAN activation. ABP only for now (see note above): set ICEGEIGER_LORAWAN_ABP to 1 and fill the three values below.
// LoRa is on by default (ICEGEIGER_ENABLE_LORA in the .ino) - to disable it, comment out that line directly.
#define ICEGEIGER_LORAWAN_ABP 0
static const uint32_t ICEGEIGER_DEV_ADDR = 0;
static const uint8_t ICEGEIGER_NWK_S_KEY[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static const uint8_t ICEGEIGER_APP_S_KEY[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
// Optional, test builds only (milliseconds between LoRaWAN uplinks; keep airtime below 1 % duty cycle):
// #define ICEGEIGER_LORA_TEST_INTERVAL_MS 60000
