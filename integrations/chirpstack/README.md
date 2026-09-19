# ChirpStack (Docker) für IceGeiger

Docker-Compose-Deployment von ChirpStack v4 (Basis: [chirpstack/chirpstack-docker](https://github.com/chirpstack/chirpstack-docker), MIT) mit den Änderungen:

- nutzt einen **vorhandenen MQTT-Broker** statt eines eigenen Mosquitto-Containers (Zugangsdaten über `.env`)
- nur Region **EU868** aktiv
- Secrets (Datenbank, API-Secret, MQTT) kommen ausschließlich aus `.env` und stehen nicht in den TOML-Dateien
- Web-Oberfläche auf Port `8180`, REST-API nur auf `127.0.0.1:8191`, Gateway Bridge auf UDP `1700`
- Speicherlimits je Container

## Start

```bash
cd integrations/chirpstack
cp .env.example .env        # lokal ausfüllen, niemals committen
docker compose up -d
GATEWAY_ID=<16 Hex-Zeichen> ./provision.py
```

`provision.py` legt zwei Device Profiles (ABP-Test und OTAA) mit dem Payload-Codec `codec.js`, die Application `IceGeiger`, das Gateway und ein ABP-Testgerät an, setzt ein zufälliges Admin-Passwort und schreibt alle erzeugten Schlüssel nach `geiger_device.json` (Dateirechte 600, nicht im Repository). Danach die Werte lokal in die `secrets.h` der Firmware übernehmen.

Der Ablauf des Testaufbaus mit einem T-Beam als Einkanal-Gateway steht in [docs/v2/05-lorawan-chirpstack.md](../../docs/v2/05-lorawan-chirpstack.md), Abschnitt 10.
