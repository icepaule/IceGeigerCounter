# V2 – Stationärer Betrieb im Schuppen

## Ziel

Wenn IceGeiger nicht mobil genutzt wird, bleibt er im Schuppen eingeschaltet und liefert kontinuierlich Umgebungswerte an Home Assistant.

## Netzwerkpriorität

1. bekanntes WLAN erreichbar → MQTT Live alle Messintervalle,
2. LoRaWAN bleibt parallel als langsamer Heartbeat/Fallback aktiv,
3. SD zeichnet weiter.

Damit lässt sich ein WLAN-Ausfall später rekonstruieren.

## Empfohlene Montage

- trocken,
- keine direkte Sonneneinstrahlung,
- nicht direkt an metallischer Außenwand, wenn LoRa genutzt wird,
- GNSS-Antenne für stationären Betrieb nicht zwingend nötig, aber unter Kunststoff und möglichst mit Himmelsrichtung montieren,
- Abstand zu Schaltnetzteilen, Motoren und stark störenden Geräten.

## Stromversorgung

Für Dauerbetrieb kann das Gerät über USB/5 V gespeist werden; der Akku dient dann als mobile Energiequelle. Ob ein echtes unterbrechungsfreies Power-Path-Verhalten mit dem finalen Aufbau sicher funktioniert, wird nach Hardwaretest dokumentiert.

## Home-Assistant-Automationen

Sinnvolle Sensoren:

- CPM aktuell,
- µSv/h abgeleitet,
- letzter Messzeitpunkt,
- GNSS Fix/Position,
- Datenquelle WiFi/LoRaWAN,
- SD-Status,
- Batteriespannung nach Verifikation.

Alarme nur auf technische Zustände (z. B. `keine Daten seit 10 min`) sind verlässlich. Strahlungsalarmgrenzen erst nach Kalibrierung bewusst setzen.
