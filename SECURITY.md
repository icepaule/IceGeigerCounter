# Security Policy / Umgang mit Zugangsdaten

Dieses Repository ist öffentlich. **Produktive Zugangsdaten gehören niemals in Git.**

## Nicht committen

- WLAN-Passwörter und private SSIDs
- MQTT-Benutzer oder Passwörter
- LoRaWAN `AppKey`, `NwkKey`, Session Keys oder produktive Join-Credentials
- InfluxDB-Tokens
- private Zertifikate oder Schlüssel
- interne Hostnamen/IP-Adressen, sofern sie nicht bewusst öffentlich sein sollen
- exportierte Home-Assistant-Backups oder Datenbankdateien
- aufgezeichnete Fahrtrouten, wenn deren Veröffentlichung nicht beabsichtigt ist

Die Firmware lädt lokale Werte aus `firmware/icegeiger_v2/secrets.h`; diese Datei ist per `.gitignore` ausgeschlossen. Als Vorlage dient `secrets.example.h`.

Die Bridge lädt ihre Zugangsdaten aus `integrations/bridge/.env`; auch diese Datei ist ausgeschlossen. Als Vorlage dient `.env.example`.

## Vor jedem Push

```bash
./scripts/security-scan.sh
```

Der Scan sucht nach typischen Geheimnissen und privaten Konfigurationswerten. Er ist eine zusätzliche Kontrolle und ersetzt keine manuelle Prüfung.

## LoRaWAN

Ein veröffentlichter OTAA-AppKey ermöglicht Missbrauch des Endgeräts. AppKey/NwkKey deshalb nur lokal in `secrets.h` speichern. DevEUI und JoinEUI sind Identifikatoren und keine geheimen Schlüssel, werden hier aber ebenfalls nur als Platzhalter versioniert.
