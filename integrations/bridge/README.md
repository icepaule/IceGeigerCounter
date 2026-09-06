# IceGeiger MQTT Bridge

Die Bridge vereinheitlicht direkte WLAN-MQTT-Messungen und ChirpStack-Uplinks. Sie erzeugt Home-Assistant-MQTT-Discovery, aktualisiert Live-Sensoren/Device-Tracker und schreibt optional historische Punkte mit Originalzeit nach InfluxDB.

```bash
cp .env.example .env
# .env nur lokal editieren
docker compose up -d --build
```

Subscriptions: `icegeiger/+/live`, `icegeiger/+/history`, `application/+/device/+/event/up`. History aktualisiert bewusst nicht den aktuellen Device-Tracker.
