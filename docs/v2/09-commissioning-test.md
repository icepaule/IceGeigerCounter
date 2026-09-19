# V2 – Inbetriebnahme und Testplan

## Test 1 – elektrische Sicherheit

- [ ] keine sichtbaren Kurzschlüsse
- [ ] beide 18650 vor gemeinsamem Einsetzen nahezu gleiche Spannung
- [ ] Polarität des Battery Shields verifiziert
- [ ] Shield-5-V-Ausgang ohne Last gemessen
- [ ] Shield-5-V-Ausgang unter Testlast stabil
- [ ] NORMAL/HOLD-Verhalten dokumentiert
- [ ] Ruhestrom in HOLD dokumentiert
- [ ] ESP32-GPIO-Pegel am GC-INT-Pegelteiler <= 3,3 V
- [ ] gemeinsame Masse vorhanden
- [ ] HV-Bereich mechanisch abgedeckt

## Test 2 – Pulszählung

- [ ] GC-1602 zählt lokal
- [ ] ESP32 zählt fallende Flanken auf GPIO17
- [ ] über 10 Minuten vergleichbare Gesamtimpulszahl
- [ ] keine massiven Doppelzählungen

## Test 3 – SD

- [ ] Karte initialisiert
- [ ] alle 10 s neue NDJSON-Zeile
- [ ] Strom aus/ein: bestehende Datei bleibt lesbar
- [ ] Sequenznummer läuft weiter

## Test 4 – GNSS

Im Freien und danach im geschlossenen Gehäuse:

- [ ] gültiger Fix
- [ ] plausible Latitude/Longitude
- [ ] Satellitenzahl > 0
- [ ] Zeitstempel plausibel UTC
- [ ] HDOP wird protokolliert
- [ ] geschlossene v1.4-Hülle verschlechtert Fix nicht unvertretbar

## Test 5 – WLAN/MQTT

- [ ] `live` Topic erscheint
- [ ] Status Topic erscheint
- [ ] Bridge empfängt
- [ ] HA Entities werden automatisch angelegt
- [ ] aktueller Device-Tracker erscheint

## Test 6 – Offline/Backfill

1. WLAN abschalten.
2. 10 Minuten weiterfahren/gehen.
3. SD-Datei prüfen: Daten müssen lückenlos weiterlaufen.
4. WLAN wieder einschalten.
5. `history` Topic beobachten.
6. Originalzeitstempel in InfluxDB prüfen.
7. Neustart während Backfill simulieren; Duplikate sind akzeptabel, Datenverlust nicht.

## Test 7 – LoRaWAN

- [ ] OTAA Join erfolgreich (Testaufbau nutzt ABP, siehe 05, Abschnitt 10)
- [x] Uplink in ChirpStack sichtbar (ABP, Einkanal-Testgateway, 19.09.2026)
- [x] Codec dekodiert Werte
- [x] Bridge erkennt `lorawan`
- [x] HA Livewerte aktualisieren sich
- [ ] InfluxDB erhält Punkt mit korrekter Position
- [ ] SMA/U.FL-Verbindung mechanisch spannungsfrei
- [ ] Reichweitentest bei geschlossenem Gehäuse

## Test 8 – Laufzeit / Shield-Eignung

Mit voll geladenen Zellen:

- [ ] Startzeit/Spannung notieren
- [ ] stationären 8-h-Test
- [ ] mobilen Test mit GNSS + LoRaWAN
- [ ] Temperatur von Battery Shield und Akkus prüfen
- [ ] Ruhestrom in HOLD erneut messen
- [ ] prüfen, ob NORMAL wegen geringer Last unerwünscht abschaltet
- [ ] reale Laufzeit dokumentieren

Erst aus diesen Messungen eine belastbare Laufzeit ableiten.

## Test 9 – Mechanik / Dichtung

- [ ] Battery Shield sitzt ohne PCB-Biegung
- [ ] unterseitiges 5-mm-Bauteil berührt den Boden nicht
- [ ] Tracker-Pins berühren Akku/Shield nicht
- [ ] Deckel schließt ohne Bauteildruck
- [ ] Beta-Kappe lässt sich abnehmen/einsetzen
- [ ] Dichtung wird gleichmäßig komprimiert
- [ ] Spritzwassertest zunächst **ohne Elektronik**
