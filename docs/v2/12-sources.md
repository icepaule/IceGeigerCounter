# V2 – Quellen und verifizierte Daten

Stand der Prüfung: 2026-09-06.

## Gekaufter Bausatz

- Amazon-Kauflink: https://amzn.eu/d/0cK2H3rO
- GC-1602-NANO Community-/Originalprojekt: https://github.com/2969773606/GeigerCounter1602nano
- dort dokumentiert: externer Interrupt-Ausgang, Nano/1602-Aufbau und Unterstützung mehrerer GM-Röhren im typischen 330–600-V-Arbeitsbereich.

## Heltec Wireless Tracker V2

- Produktseite: https://heltec.org/project/wireless-tracker-v2/
- Heltec ESP32 Framework: https://github.com/HelTecAutomation/Heltec_ESP32
- Zephyr Board-Dokumentation / Pinout: https://github.com/zephyrproject-rtos/zephyr/tree/main/boards/heltec/heltec_wireless_tracker

Verifizierte Kernpunkte:

- ESP32-S3FN8,
- SX1262,
- UC6580 GNSS,
- 863–928 MHz Hardwarebereich,
- Lithium-Akku-Management,
- GNSS UART auf GPIO33/34,
- Heltec stellt LoRaWAN- und GPS-Beispiele bereit.

## LoRaWAN EU868

- The Things Network EU863-870: https://www.thethingsnetwork.org/docs/lorawan/regional-parameters/eu868/
- LoRa Alliance Regional Parameters: https://lora-alliance.org/resource_hub/rp2-1-0-3-lorawan-regional-parameters/

Wichtig:

- EU863-870,
- Default-Kanäle 868.1 / 868.3 / 868.5 MHz,
- Duty-Cycle-/Sendeleistungsgrenzen beachten,
- typische LoRaWAN-Max-EIRP-Vorgabe in EU868: +16 dBm; lokale/regulatorische Randbedingungen bleiben maßgeblich.

## ChirpStack

- Docker: https://github.com/chirpstack/chirpstack-docker
- MQTT Integration: https://www.chirpstack.io/docs/chirpstack/integrations/mqtt.html

Standard-Uplinktopic:

`application/<APPLICATION_ID>/device/<DEV_EUI>/event/up`

## Home Assistant

- MQTT Sensor: https://www.home-assistant.io/integrations/sensor.mqtt/
- MQTT Device Tracker: https://www.home-assistant.io/integrations/device_tracker.mqtt/

MQTT Device Tracker kann GPS-Koordinaten über JSON-Attribute mit `latitude`, `longitude` und optional `gps_accuracy` übernehmen.

## Softwarebibliotheken

- arduino-mqtt: https://github.com/256dpi/arduino-mqtt
- ArduinoJson: https://arduinojson.org/

## Unsicher / nach Lieferung zu verifizieren

- tatsächlich geliefertes Zählrohr,
- exakter INT-Ruhe- und Pulspegel des Amazon-Boards,
- PCB- und Lochmaße,
- realer Stromverbrauch,
- Akku-Spannungsmessung des Heltec im konkreten Boardstand,
- endgültiger CPM→µSv/h-Faktor.
