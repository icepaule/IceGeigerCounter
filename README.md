# IceGeigerCounter

DIY-Geigerzähler auf Basis eines **Wemos ESP-WROOM-02** (ESP8266) mit integriertem 18650-Akkufach, einem GM-Röhren-Modul, 0,96" OLED-Display und Piezo-Sound, in einem kompakten 3D-gedruckten Gehäuse.

## Status

- [x] Hardware ausgewählt & Kompatibilität geprüft (Chip live via `esptool` verifiziert: ESP8266EX)
- [x] Stromversorgung geklärt (5V-Pin am Board vom TP5400-Booster nutzbar)
- [x] Firmware-Wahl getroffen
- [ ] Bauteile bestellt
- [ ] Verkabelung aufgebaut
- [ ] Firmware geflasht & konfiguriert
- [ ] Gehäuse gedruckt & montiert
- [ ] Kalibrierung / erster Dauertest

## Doku-Struktur

1. [Stückliste](docs/01-parts-list.md)
2. [Verkabelung](docs/02-wiring.md)
3. [Firmware](docs/03-firmware.md)
4. [Gehäuse](docs/04-enclosure.md)
5. [Zusammenbau](docs/05-assembly.md)
6. [Selbstgebaute Hochspannungsschaltung (HV-Generator)](docs/06-hv-circuit.md) ⚠️ Sicherheitshinweise beachten

## Sicherheitshinweise

- Die selbstgebaute HV-Schaltung (siehe [06-hv-circuit.md](docs/06-hv-circuit.md)) erzeugt intern ca. 400V für die Geiger-Müller-Röhre. Nicht bei angeschlossener Spannungsquelle an HV-Bauteile fassen, vor Berührung immer Spannungsquelle trennen und Speicherkondensator entladen.
- Für den Betrieb wird keine radioaktive Prüfquelle benötigt – natürliche Hintergrundstrahlung reicht zum Testen der Funktion aus.
