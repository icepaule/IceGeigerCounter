# V2 – Validierungsstatus

Diese Datei trennt bewusst **verifiziert**, **statisch geprüft** und **noch hardwareabhängig**.

## Verifiziert aus öffentlichen Quellen
- [x] GC-1602-NANO besitzt externen Interrupt-Ausgang und Nano/1602-Konzept.
- [x] Heltec Wireless Tracker V2 kombiniert ESP32-S3, SX1262 und UC6580.
- [x] GNSS UART GPIO33/34 ist in Heltec-Beispielen belegt.
- [x] Heltec stellt LoRaWAN/GPS-Beispiele bereit.
- [x] ChirpStack publiziert Uplinks per MQTT.
- [x] Home Assistant MQTT Device Tracker unterstützt GPS-Koordinaten.

## Im Repository statisch geprüft
- [x] Firmware enthält keine produktiven Credentials; `secrets.h` ist ausgeschlossen.
- [x] ChirpStack Codec besitzt lokalen Test.
- [x] Bridge besitzt Payload-/Normalisierungstest und optionale InfluxDB-Anbindung.
- [x] OpenSCAD ist library-frei und generiert die vorgesehenen Teile.
- [x] PRELIMINARY-STLs sind vorhanden; FINAL-Geometrie ist explizit von realer Vermessung abhängig.
- [x] Secret-Scan-Skript ist enthalten.

## Noch nicht real geprüft
- [ ] exakter Pegel und Pulsform des gelieferten GC-1602-INT
- [ ] tatsächlich geliefertes Zählrohr und CPM-Faktor
- [ ] endgültige Gehäusepassung / Loch- und Buchsenpositionen
- [ ] microSD-SPI-Pins am konkreten Wireless Tracker V2 Boardstand
- [ ] Gesamtstrom / Laufzeit / Ladeszenario
- [ ] LoRaWAN-Uplink in realem ChirpStack und Reichweite
- [ ] GNSS-Fix im endgültigen Gehäuse

## Freigabekriterium `FINAL`
Erst Messliste ausfüllen, Fit-Jig erfolgreich testen, elektrische Pegel prüfen und vollständigen Inbetriebnahmeplan abarbeiten. Erst danach STL-Dateien als `FINAL` freigeben.
