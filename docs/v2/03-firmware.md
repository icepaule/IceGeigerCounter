# V2 – Firmware installieren und konfigurieren

Die Firmware liegt in `firmware/icegeiger_v2/icegeiger_v2.ino`.

## Voraussetzungen

- Arduino IDE 2.x
- aktuelles Heltec ESP32 Board-Package / Heltec ESP32 Framework
- Board: **Wireless Tracker V2**
- LoRaWAN Region: **EU868 / EU863-870**

Benötigte Bibliotheken:

- Heltec ESP32 / `LoRaWan_APP.h`
- `HT_TinyGPS++.h` aus dem Heltec-Paket
- `arduino-mqtt` von 256dpi
- ArduinoJson 7
- ESP32 `WiFi`, `SD`, `SPI`

## 1. Secrets anlegen

```bash
cd firmware/icegeiger_v2
cp secrets.example.h secrets.h
```

Danach **nur lokal** `secrets.h` editieren:

- WLAN SSID/Passwort,
- MQTT Host/Port/Benutzer/Passwort,
- LoRaWAN DevEUI/JoinEUI/AppKey.

`secrets.h` ist in `.gitignore` enthalten.

## 2. Konfiguration

Die nicht geheimen Projektparameter stehen oben in `icegeiger_v2.ino`:

- `DEVICE_ID`
- `GC_INT_PIN = 47`
- SD-Pins 4/5/6/7
- Log-Intervall 10 s
- LoRaWAN-Intervall mobil 120 s
- LoRaWAN-Heartbeat stationär 900 s
- vorläufiger CPM→µSv/h-Faktor

Den Faktor erst nach Identifikation des gelieferten Zählrohrs bewusst bestätigen.

## 3. Flashen

1. Heltec per USB-C anschließen.
2. In Arduino IDE `Wireless Tracker V2` auswählen.
3. Region `EU868` wählen.
4. Sketch kompilieren.
5. Upload starten.
6. Seriellen Monitor mit 115200 Baud öffnen.

Falls das Board nicht in den Bootloader geht: USER/BOOT halten, RESET kurz drücken und anschließend erneut flashen.

## 4. Startdiagnose

Die Firmware meldet beim Booten:

- SD initialisiert oder Fehler,
- GNSS gestartet,
- WLAN verbunden/nicht erreichbar,
- MQTT verbunden/nicht erreichbar,
- LoRaWAN-Joinstatus über Heltec-Ausgaben.

Das Gerät muss **auch ohne WLAN und ohne LoRaWAN** weiter zählen und auf SD schreiben.

## 5. MQTT Topics

Direkter WLAN-Pfad:

- `icegeiger/<device>/live`
- `icegeiger/<device>/history`
- `icegeiger/<device>/status`

Die Bridge verarbeitet diese Topics und erzeugt daraus Home-Assistant-Discovery sowie InfluxDB-Daten.

## 6. Firmware-Design

Die Firmware ist absichtlich nicht auf Deep Sleep optimiert. Der Geiger-INT muss kontinuierlich gezählt werden und alle 10 s wird ein Datensatz geschrieben. Die Heltec-LoRaWAN-State-Machine wird deshalb weiter bedient, ohne den ESP32 zwischen den LoRa-Zyklen in den tiefen Schlaf zu schicken.

## 7. Verifikation nach Hardwarelieferung

Vor dauerhaftem Einsatz:

- 1 Stunde Hintergrundmessung mit seriellem Counter gegen LCD vergleichen,
- SD-Datei prüfen,
- GNSS-Fix im Freien prüfen,
- WLAN/MQTT Livepfad prüfen,
- WLAN abschalten → weiterloggen,
- WLAN wieder einschalten → Backfill prüfen,
- LoRaWAN Join und Uplink prüfen.
