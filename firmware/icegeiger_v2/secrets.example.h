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
