# V2 – Stationärer Betrieb im Schuppen

## Ziel

Wenn IceGeiger nicht mobil genutzt wird, bleibt er im Schuppen eingeschaltet und liefert kontinuierlich Umgebungswerte an Home Assistant.

## Netzwerkpriorität

1. bekanntes WLAN erreichbar → MQTT Live alle Messintervalle,
2. LoRaWAN bleibt parallel als langsamer Heartbeat/Fallback aktiv,
3. SD zeichnet weiter.

## Empfohlene Montage

- trocken,
- keine direkte Sonneneinstrahlung,
- nicht direkt an metallischer Außenwand, wenn LoRa genutzt wird,
- GNSS-Antennenbereich unter Kunststoff und möglichst frei von Metall,
- Abstand zu Schaltnetzteilen, Motoren und stark störenden Geräten.

## Stromversorgung mit Battery Shield

Field Case v1.4 verwendet das integrierte duale 18650 Battery Shield.

Vor Dauerbetrieb unbedingt messen:

- 5-V-Ausgangsstabilität,
- Ladeverhalten,
- Ruhestrom in HOLD,
- Abschaltschwelle in NORMAL,
- Temperatur des Shields bei Dauerlast.

Bei verbreiteten Shields dieser Familie kann NORMAL bei geringer Last automatisch abschalten. HOLD verhindert das, kann bei manchen Revisionen aber zusätzlichen Ruhestrom verursachen. Für einen Schuppensensor ist daher der **gemessene** Dauerverbrauch wichtiger als die Verkäuferangabe.

Wenn der gemessene HOLD-Verbrauch zu hoch ist, sollte für den stationären Betrieb eine alternative externe 5-V-Versorgung bzw. ein eigener Low-Quiescent-Current-Power-Path verwendet werden; das Battery Shield bleibt dann primär mobile Versorgung.

## Home-Assistant-Automationen

Sinnvolle Sensoren:

- CPM aktuell,
- µSv/h abgeleitet,
- letzter Messzeitpunkt,
- GNSS Fix/Position,
- Datenquelle WiFi/LoRaWAN,
- SD-Status,
- Batteriespannung nach Verifikation.

Technische Alarme wie `keine Daten seit 10 min` sind belastbar. Strahlungsalarmgrenzen erst nach Kalibrierung bewusst setzen.
