# V2 – Firmware installieren und konfigurieren

Die Firmware liegt in `firmware/icegeiger_v2/icegeiger_v2.ino`.

## Hardwareprofil

Zielhardware ist das gelieferte **HITT-Tracker V1.2**. Es verwendet real SX1262 + UC6580 und entspricht elektrisch weitgehend der dokumentierten Heltec Wireless-Tracker-V1.1-Familie. Nicht die Amazon-Titelangabe „SX1276“ verwenden.

## Voraussetzungen

- Arduino IDE 2.x
- aktuelles Heltec ESP32 Board-Package / Framework
- Boardprofil **Wireless Tracker** bzw. das zum installierten Heltec-Paket passende Tracker-Profil
- Region **EU868 / EU863-870**
- `LoRaWan_APP.h`
- `HT_TinyGPS++.h`
- `arduino-mqtt` (256dpi)
- ArduinoJson 7

## Lokale Secrets

```bash
cd firmware/icegeiger_v2
cp secrets.example.h secrets.h
```

Nur lokal setzen: WLAN, MQTT, DevEUI, JoinEUI, AppKey. `secrets.h` wird nicht eingecheckt.

## Aktuelle Pinbelegung

- GC-1602 INT: **GPIO7**, ein 150-kΩ-Vorwiderstand, **kein** Pfad nach GND (Begründung: [02-electrical-wiring.md](02-electrical-wiring.md))
- microSD: SCK=4, MISO=5, MOSI=6, CS=**15** (deaktiviert per `#ifdef ICEGEIGER_ENABLE_SD`, solange keine Karte verbaut ist)
- GNSS: RX=33, TX=34, Versorgung über GPIO3 HIGH
- VBAT read: GPIO1, Skalierung 4.9 laut Heltec-Dokumentation

## LoRaWAN: RadioLib statt Heltec LoRaWan_APP, standardmäßig aktiv

Die Heltec-LoRaWan_APP-Bibliothek stürzte beim Senden reproduzierbar mit einem Interrupt-Watchdog-Panic ab (Core-1-ISR, nicht unsere drawStatus()/SPI-Logik – per `addr2line` verifiziert und auch bei komplett abgeschaltetem TFT-Refresh weiterhin reproduzierbar, siehe [05-lorawan-chirpstack.md](05-lorawan-chirpstack.md) Abschnitt 10.5). Am 22.10.2026 durch [RadioLib](https://github.com/jgromes/RadioLib) ersetzt (eigene `LoRaWANNode`-Anbindung auf dem SX1262, eigenes Single-Channel-Band passend zum T-Beam-Testgateway) – seitdem per `ICEGEIGER_ENABLE_LORA` standardmäßig aktiv, über mehrere Minuten stabil ohne Absturz verifiziert. WLAN/MQTT bleibt der primäre Pfad; LoRa dient zusätzlich als Fallback, siehe [05-lorawan-chirpstack.md](05-lorawan-chirpstack.md) Abschnitt 10.6.

## Betriebslogik

- alle 10 s Rohdatensatz auf SD
- rollender 60-s-CPM-Wert
- WLAN/MQTT bevorzugt
- LoRaWAN mobil als Live-Telemetrie, SD bleibt Primärablage
- bei WLAN-Reconnect Backfill über `icegeiger/<device>/history`
- Batteriewert wird mit jedem Messpunkt protokolliert

## Vor dem ersten Anschluss des GC-1602

1. INT-Ruhe- und Pulspegel messen.
2. Pegelteiler allein aufbauen.
3. Ausgang am GPIO-Knoten messen; maximal etwa 3,3 V.
4. Erst danach GPIO17 verbinden.

## Hardwaretest nach GC-Lieferung

- 1 h Impulsvergleich Tracker ↔ GC-LCD
- SD-Logging ohne WLAN
- WLAN-Reconnect und Backfill
- GNSS-Fix im geschlossenen Gehäuse
- LoRaWAN Join/Uplink EU868
- Batterieanzeige gegen Multimeter
