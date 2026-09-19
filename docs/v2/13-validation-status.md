# V2 – Validierungsstatus

## Real verifiziert

- [x] gelieferter Tracker trägt `HITT-Tracker V1.2`
- [x] SX1262 auf realer Platine ablesbar
- [x] UC6580 auf realer Platine ablesbar
- [x] Tracker-Display und Werksfirmware laufen per USB
- [x] Tracker-Hülle aus Maßzeichnung: 65,84 × 28,00 × ca. 14,71 mm
- [x] Stiftleisten sind bereits verlötet; CAD berücksichtigt 6,1-mm-Pinunterstand
- [x] duales Battery Shield real vorhanden
- [x] Battery Shield real gemessen: **100,2 × 48,0 mm**
- [x] unterseitiges Shield-Bauteil mit ca. **5 mm** Höhe in CAD berücksichtigt

## Real verifiziert – GC-1602-NANO Bausatz (19.09.2026)

- [x] GC-1602-NANO Bausatz geliefert und läuft eigenständig über den Nano-USB-Anschluss
- [x] LCD zeigt CPM und µSv/h
- [x] Piezo klickt bei Impulsen
- [x] Nano meldet sich am Linux-Host als CH340 (`1a86:7523`, `ch341-uart`) und erscheint als `/dev/ttyUSB1`
- [x] Die gelieferte Firmware gibt **nichts über Serial** aus: 65 s bei 9600 Baud, 12 s bei 115200 Baud und 15 s bei 57600 Baud ergaben jeweils 0 Bytes. Der Upstream-Sketch ([WinHGGG/Geiger-Counter-v1.3-LCD-CAJOE](https://github.com/WinHGGG/Geiger-Counter-v1.3-LCD-CAJOE)) hat `Serial.begin` auskommentiert. Die Impulse müssen daher direkt am INT-Pin abgegriffen werden (Tracker-Pfad, siehe [02-electrical-wiring.md](02-electrical-wiring.md)); ohne Neuflashen des Nano ist der USB-Anschluss dafür nicht nutzbar.
- [x] Der Upstream-Sketch zählt Impulse über INT0 (Nano D2) auf der fallenden Flanke, misst in 15-s-Fenstern und rechnet `µSv/h = CPM / 151`. Das ist die Upstream-Referenz; die Firmware der gelieferten Einheit wurde nicht ausgelesen.
- [x] **INT-Ruhepegel:** Multimeter (DC) zwischen Nano-Pin D2 und GND zeigt **4,39 V**, bei USB-Versorgung über den Nano und ohne angeschlossene Last. Der Ruhepegel ist High (5-V-Logik, der Wert liegt unter 5 V, weil er der Versorgung folgt). Das Multimeter mittelt bei niedriger Zählrate über kurze Low-Impulse, der Wert entspricht daher dem Ruhepegel. Mit dem 10-kΩ/20-kΩ-Teiler ergibt das ca. **2,93 V** am GPIO. Das liegt über der ESP32-S3-Schwelle für High von 0,75 × VDD (etwa 2,5 V bei 3,3 V, [Datenblatt](https://documentation.espressif.com/esp32-s3_datasheet_en.html)) und unter dem Grenzwert von VDD + 0,3 V (3,6 V). Der Pegel folgt der 5-V-Schiene und muss beim Betrieb am Battery Shield erneut gemessen werden.

Hinweis: Die Röhre im GC-1602-NANO ist laut Upstream-Beschreibung eine J305. Der Faktor 151 ist ein Standardwert und keine Kalibrierung dieser Einheit; siehe [10-calibration-data-quality.md](10-calibration-data-quality.md).

## Real verifiziert – Firmware, Netz, LoRaWAN-Testkette (19.09.2026)

- [x] V2-Firmware baut mit Heltec-Paket 3.3.8; zwei Fehler behoben (fehlendes `appTxDutyCycle`, keine LoRa-Sendung ohne Schlüssel)
- [x] Tracker verbindet sich mit WLAN und MQTT; alle 10 s ein Datensatz auf `icegeiger/icegeiger-v2/live`
- [x] TFT-Statusanzeige und serielle Statuszeile laufen; GNSS liefert NMEA-Daten (noch kein Fix, Test drinnen)
- [x] Ohne GNSS-Fix meldet der UC6580 ein altes RTC-Datum; `ts` wird deshalb nur mit Fix gesetzt
- [x] ChirpStack v4 als Docker-Stack auf dem Home-Assistant-Host, Anbindung an den vorhandenen MQTT-Broker
- [x] **LoRaWAN-Uplink (ABP, Einkanal-Testgateway)**: Tracker → T-Beam → ChirpStack → MQTT → Bridge → Home Assistant; Codec dekodiert die Nutzdaten. Details in [05-lorawan-chirpstack.md](05-lorawan-chirpstack.md), Abschnitt 10
- [x] Antenne am Tracker angeschlossen; der Nahbereichsempfang belegt, dass der Sender arbeitet, aber nicht die Reichweite

Offen in diesem Bereich: OTAA-Join mit einem echten Multi-Channel-Gateway, Reichweite, SD-Karte zusammen mit dem Display (beide nutzen HSPI), Akkumessung (Anzeige 0 mV ohne Akku, Skalierung ungeprüft).

## Aus Hersteller-/Projektunterlagen plausibilisiert

- [x] Heltec-V1.1-Familie: ESP32-S3FN8 + SX1262 + UC6580
- [x] GPIO33/34 = GNSS UART, GPIO3 HIGH schaltet GNSS-Versorgung bei V1.1
- [x] LoRa belegt GPIO8–14; TFT GPIO38–42
- [x] duale Shield-Familie DFR0969/OKY3604-2-artig besitzt typischerweise 5-V-Ausgang, Lade-/Schutzschaltung und HOLD/NORMAL

## CAD / statisch geprüft – Field Case v1.4

- [x] eigenständiger OpenSCAD-Entwurf ohne externe Bibliotheken
- [x] integrierte Battery-Shield-Schienen, je 5 × 5 mm an den kurzen Enden
- [x] 1,2 mm berechneter Freiraum unter dem 5-mm-Unterseitenbauteil
- [x] herausnehmbare Service-Brücke für Tracker + microSD
- [x] Tracker-Pinreihen erhalten offene Durchbrüche
- [x] GNSS-Bereich unter der Patchantenne ist offen
- [x] Beta-Fenster mit Membran + Schutzkappe
- [x] umlaufende 2-mm-Silikondichtung und acht M3-Anpresspunkte
- [x] `check_fit.py` prüft die wichtigsten statischen Freiräume
- [x] lokale STL-Exporte waren watertight; GitHub Actions reproduziert die Repository-STLs

## Noch physisch zu testen

- [ ] realer Print von Base/Lid/Service-Bridge
- [ ] reale Shield-Schraubpositionen in die massiven Schienen bohren
- [ ] tatsächliche GC-1602 PCB-Länge/Breite
- [ ] GC-Lochabstände und Lochdurchmesser
- [ ] reale GC-Bauhöhe / LCD-Position
- [ ] Zählrohr-Aufschrift und Rohrmittelpunkt
- [ ] realer INT-Pulspegel (Low-Pegel und Pulsform, z. B. mit Oszilloskop oder Logikanalysator); der Ruhepegel ist gemessen, siehe oben
- [ ] Battery-Shield 5-V-Ausgang unter Last
- [ ] Battery-Shield NORMAL/HOLD/Ruhestrom
- [ ] CPM→µSv/h-Faktor
- [ ] GNSS-Fix im geschlossenen Gehäuse
- [ ] LoRaWAN-Uplink / Reichweite
- [ ] Dichtungs- und Spritzwassertest zunächst ohne Elektronik

## Statusbezeichnung

Field Case v1.4 ist der aktuelle **Print Candidate**. Nach erfolgreicher realer Passprobe und den elektrischen Shield-Tests kann dieser Stand als hardware-validiert markiert werden.
