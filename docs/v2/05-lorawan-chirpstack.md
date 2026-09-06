# V2 – LoRaWAN + ChirpStack Schritt für Schritt

## 0. Was LoRaWAN hier leistet

LoRaWAN transportiert kleine Live-Telemetriepakete. Es ersetzt **nicht** die SD-Karte und funktioniert nur in Reichweite eines passenden Gateways.

Für Deutschland wird IceGeiger als **EU863-870 / EU868** konfiguriert. Die Firmware sendet bewusst deutlich seltener als die lokale 10-s-Aufzeichnung.

## 1. Gateway vorbereiten

Benötigt wird ein echter Multi-Channel-LoRaWAN-Concentrator, z. B. SX1302/SX1303-basierend, EU868.

Gateway so konfigurieren, dass es mit dem eigenen ChirpStack spricht:

- bevorzugt LoRa Basics Station oder
- ChirpStack Gateway Bridge.

Ein normales SX1262-Endgerät kann diesen Gateway-Concentrator nicht ersetzen.

## 2. ChirpStack per Docker installieren

Empfohlener Weg ist das offizielle Docker-Beispielprojekt von ChirpStack.

```bash
git clone https://github.com/chirpstack/chirpstack-docker.git
cd chirpstack-docker
docker compose up -d
```

Danach Weboberfläche öffnen und:

1. Tenant anlegen bzw. Default-Tenant nutzen.
2. EU868 Device Profile anlegen.
3. Application `IceGeiger` anlegen.
4. Gateway mit seiner Gateway-ID registrieren.
5. Endgerät registrieren.

## 3. OTAA-Endgerät anlegen

In ChirpStack:

- Device Profile: LoRaWAN Class A, Region EU868,
- Device Name: `icegeiger-v2`,
- DevEUI: aus lokaler `secrets.h`,
- JoinEUI/AppEUI: passend zur Konfiguration,
- AppKey: **nur lokal und in ChirpStack**, niemals ins öffentliche GitHub-Repo.

## 4. Payload Codec hinterlegen

Den Inhalt von `integrations/chirpstack/codec.js` als JavaScript Payload Codec für das Device Profile bzw. die Application konfigurieren.

Der Decoder liefert u. a.:

- `seq`
- `timestamp`
- `cpm`
- `counts_10s`
- `latitude`
- `longitude`
- `battery_mv`
- `satellites`
- `hdop`
- `factor_cpm_per_usvh`
- `usvh`

## 5. MQTT prüfen

ChirpStack veröffentlicht Uplinks standardmäßig auf einem Topic nach dem Muster:

`application/<APPLICATION_ID>/device/<DEV_EUI>/event/up`

Test:

```bash
mosquitto_sub -h <MQTT-HOST> -t 'application/+/device/+/event/up' -v
```

## 6. IceGeiger Bridge starten

Die Bridge verarbeitet sowohl ChirpStack-Uplinks als auch direkte WLAN-Publishes.

```bash
cd integrations/bridge
cp .env.example .env
# .env lokal editieren
docker compose up -d --build
```

## 7. Uplink-Strategie

Defaultwerte im Projekt:

| Modus | LoRaWAN Intervall |
|---|---:|
| WLAN verfügbar / Schuppen | 900 s Heartbeat |
| mobil ohne WLAN | 120 s |
| SD Logging | 10 s unabhängig davon |

Die Intervalle können angepasst werden. Höhere Sendehäufigkeit erhöht Energieverbrauch und Airtime und ist regulatorisch/netzseitig begrenzt.

## 8. Sendeleistung

Der Wireless Tracker V2 kann hardwareseitig eine hohe Ausgangsleistung bereitstellen. Für EU868 darf die Firmware **nicht einfach die maximale Hardwareleistung verwenden**. Regionale LoRaWAN-/ETSI-Grenzen und Antennengewinn müssen eingehalten werden. Das Projekt verlässt sich auf die EU868-Konfiguration des LoRaWAN-Stacks und dokumentiert keine 28-dBm-Nutzung für Deutschland.

## 9. Reichweite realistisch bewerten

Ein Gateway im Schuppen oder Haus kann je nach Antennenhöhe, Bebauung und Gelände von einigen hundert Metern bis mehreren Kilometern reichen; eine konkrete Reichweite lässt sich vor Ort nicht seriös vorhersagen.

Für Fahrten außerhalb der eigenen Gateway-Abdeckung:

- SD bleibt vollständig,
- WLAN-Backfill erfolgt nach Rückkehr,
- Live-LoRaWAN erfordert ein Netz/Gateway, das die Route tatsächlich abdeckt.
