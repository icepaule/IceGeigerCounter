# IceGeiger V2 Firmware

Target: **Heltec Wireless Tracker V2** (ESP32-S3 + SX1262 + UC6580).

## Install

1. Arduino IDE 2.x installieren.
2. Heltec ESP32 Board-Support gemäß Hersteller installieren.
3. Board `Wireless Tracker V2` und Region `EU868` auswählen.
4. Libraries installieren: `arduino-mqtt` (256dpi), `ArduinoJson` 7.
5. `secrets.example.h` nach `secrets.h` kopieren und lokal ausfüllen.
6. `icegeiger_v2.ino` öffnen, kompilieren und flashen.

## Important

The firmware deliberately keeps the MCU awake. It must count the GC interrupt continuously and write a record every 10 seconds. The Heltec LoRaWAN timer/IRQ state machine is serviced without calling its deep-sleep helper.

`battery_mv` is currently reported as `0` until the battery-ADC path has been verified on the exact delivered Wireless Tracker V2 hardware revision. This avoids publishing a fabricated voltage.
