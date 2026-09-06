# V2 – Offline-Logging und WLAN-Backfill

## Grundsatz

Die microSD ist die zuverlässige lokale Primärablage für mobile Fahrten. Funkübertragung ist zusätzlich.

## Dateiformat

Die Firmware schreibt newline-delimited JSON (`NDJSON`) nach:

`/icegeiger/log.ndjson`

Beispiel:

```json
{"seq":1234,"ts":1788703200,"counts_10s":3,"cpm_60s":18,"usvh":0.119,"factor_cpm_per_usvh":151.0,"lat":48.100001,"lon":11.600001,"satellites":12,"hdop":0.9,"gps_valid":true,"battery_mv":0}
```

Jede Zeile ist unabhängig parsebar. Ein beschädigtes Dateiende nach abruptem Stromverlust zerstört damit nicht die vorherigen Messpunkte.

## Sync-Cursor

Die Datei `/icegeiger/sync.cursor` enthält die zuletzt erfolgreich bestätigte Dateiposition.

Ablauf:

1. Messpunkt auf SD append.
2. Wenn MQTT verfügbar ist, Livewert senden.
3. Backfill-Datei am Cursor öffnen.
4. Eine Zeile lesen.
5. Als MQTT QoS 1 auf `icegeiger/<device>/history` senden.
6. Nur wenn `publish()` erfolgreich zurückkehrt, Cursor fortschreiben.
7. Bei Fehler stoppen und später erneut versuchen.

Ein Stromausfall kann dadurch im ungünstigsten Fall zu **Duplikaten**, nicht aber bewusst zu übersprungenen Datensätzen führen. Die InfluxDB-Seite kann über Sequenznummer und Zeitstempel deduplizieren bzw. gleiche Punkte überschreiben.

## Zeitstempel

GNSS-Zeit ist bevorzugt. Solange noch kein gültiger GNSS-Zeitstempel vorliegt, wird `ts=0` gespeichert und der Messpunkt bleibt dennoch erhalten. Die Bridge verwirft solche Punkte nicht, markiert sie aber als nicht zeitverifiziert.

## Kartenqualität

Ein 10-s-Fenster enthält bei natürlicher Hintergrundstrahlung oft nur wenige Pulse. Für die Darstellung auf einer Karte sollte deshalb **nicht jeder einzelne 10-s-Wert als harte Dosisfarbgrenze interpretiert werden**.

Empfehlung:

- Rohdaten: 10 s,
- CPM: gleitend 60 s,
- Karte: optional räumlich 25–50 m oder zeitlich 60–120 s aggregieren.

## SD-Kartenwechsel

Vor Entfernen der Karte Gerät ausschalten. FAT-Dateisystem regelmäßig sichern. Für häufiges Logging eine High-Endurance/Industrial-Karte bevorzugen.
