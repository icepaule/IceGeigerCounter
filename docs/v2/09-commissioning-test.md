# V2 – Inbetriebnahme und Testplan

## Test 1 – elektrische Sicherheit

- [ ] keine sichtbaren Kurzschlüsse
- [ ] 5-V-Boost gemessen: 5,0 V ± sinnvoller Toleranz
- [ ] ESP32-GPIO-Pegel am Pegelteiler <= 3,3 V
- [ ] gemeinsame Masse vorhanden
- [ ] HV-Bereich mechanisch abgedeckt

## Test 2 – Pulszählung

- [ ] GC-1602 zählt lokal
- [ ] ESP32 zählt fallende Flanken
- [ ] über 10 Minuten vergleichbare Gesamtimpulszahl
- [ ] keine massiven Doppelzählungen

Kleine Abweichungen können durch unterschiedliche Zeitfenster entstehen. Größere Abweichungen zuerst elektrisch untersuchen.

## Test 3 – SD

- [ ] Karte initialisiert
- [ ] alle 10 s neue NDJSON-Zeile
- [ ] Strom aus/ein: bestehende Datei bleibt lesbar
- [ ] Sequenznummer läuft weiter

## Test 4 – GNSS

Im Freien:

- [ ] gültiger Fix
- [ ] plausible Latitude/Longitude
- [ ] Satellitenzahl > 0
- [ ] Zeitstempel plausibel UTC
- [ ] HDOP wird protokolliert

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
6. Prüfen, dass die Originalzeitstempel nach InfluxDB gelangen.
7. Neustart während Backfill simulieren; Duplikate sind akzeptabel, Datenverlust nicht.

## Test 7 – LoRaWAN

- [ ] OTAA Join erfolgreich
- [ ] Uplink in ChirpStack sichtbar
- [ ] Codec dekodiert Werte
- [ ] Bridge erkennt `lorawan`
- [ ] HA Livewerte aktualisieren sich
- [ ] InfluxDB erhält Punkt mit korrekter Position

## Test 8 – Laufzeit

Mit voll geladenem Pack:

- [ ] Startzeit/Spannung notieren
- [ ] stationären 8-h-Test
- [ ] mobilen Test mit GNSS + LoRaWAN
- [ ] Temperatur des Boost-Wandlers und Akkus prüfen

Erst aus diesen Messungen eine belastbare Laufzeit ableiten.
