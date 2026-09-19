# Home Assistant

Die Bridge veröffentlicht MQTT-Discovery automatisch. Nach dem Start erscheinen CPM, abgeleitete µSv/h, Satellitenzahl, HDOP, Akkuspannung und ein GPS Device Tracker. Für historische Routen wird Grafana/InfluxDB empfohlen; Backfill-Punkte werden nicht als aktuelle Position wiedergegeben.

## Entity-IDs und Dashboard

Discovery erzeugt lange Entity-IDs (`sensor.icegeiger_icegeiger_v2_icegeiger_cpm`). `setup_entities.py` benennt sie in kurze IDs um und legt das Dashboard `lovelace-icegeiger` (aus `dashboard.yaml`) im Storage-Modus an. Ein Neustart von Home Assistant ist dafür nicht nötig.

```bash
HA_URL=ws://<host>:8123/api/websocket HA_TOKEN=<Long-Lived-Access-Token> python3 setup_entities.py
```

Das Skript ändert nur die genannten Entities und das Dashboard `lovelace-icegeiger`. Zugangsdaten werden nicht gespeichert.

| Kurz-ID | Bedeutung |
|---|---|
| `sensor.icegeiger_cpm` | Impulse pro Minute (60-s-Fenster) |
| `sensor.icegeiger_usvh` | abgeleitete Dosisleistung (Faktor 151, nicht kalibriert) |
| `sensor.icegeiger_gnss_satellites` / `_hdop` | GNSS-Qualität |
| `sensor.icegeiger_battery_mv` | Akkuspannung |
| `device_tracker.icegeiger_v2` | letzte Position mit GNSS-Fix |

Übertragungen ohne GNSS-Fix (LoRaWAN-Payload mit Koordinaten 0/0) verändern die Position nicht.
