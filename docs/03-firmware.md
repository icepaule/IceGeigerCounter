# Firmware

## Wahl: ESPGeiger

Projekt: [steadramon/ESPGeiger](https://github.com/steadramon/ESPGeiger), Doku: [docs.espgeiger.com](https://docs.espgeiger.com)

Begründung:
- Aktiv gepflegt, umfangreiche Doku-Website, Web-Installer (kein lokales Toolchain-Setup nötig)
- Native ESP8266-Unterstützung mit dedizierten OLED-Build-Varianten
- OLED-Auto-Detect (SSD1306/SH1106/SSD1309)
- Eingebautes "Audio Tick"-Feature für Klick-Sound am Piezo
- MQTT + Home-Assistant-Integration vorhanden
- OTA-Updates, Offline-Modus

## Geplanter Ablauf (wird nach Durchführung ergänzt)

1. Board über USB verbinden, Web-Installer von docs.espgeiger.com nutzen (Build-Variante für ESP8266 + OLED wählen)
2. Konfiguration: WLAN-Zugangsdaten, GM-Tube-Pin (D7 / GPIO13), Audio-Tick aktivieren (D6 / GPIO12)
3. Kalibrierfaktor für J305-Röhre setzen (Richtwert ca. 151 CPM = 1 µSv/h, exakter Wert laut Datenblatt des jeweiligen Tube-Moduls prüfen)
4. MQTT-Broker-Zugangsdaten hinterlegen für Home-Assistant-Integration
5. Funktionstest: Zählt das Gerät Hintergrundstrahlung plausibel (typisch einige CPM)?

> Status: Firmware wird erst geflasht, nachdem Hardware/Verkabelung vollständig aufgebaut ist (siehe [05-assembly.md](05-assembly.md)).
