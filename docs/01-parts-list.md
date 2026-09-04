# Stückliste

| Komponente | Modell | Menge | Anmerkung |
|---|---|---|---|
| Mikrocontroller-Board | Wemos ESP-WROOM-02 mit 18650-Akkuhalterung (ESP8266EX, TP5400 Lade-/Boost-IC, AMS1117 3,3V-Regler, CP2102 USB-UART) | 1 | Chip live verifiziert per `esptool`: ESP8266EX, 160MHz |
| Akku | 18650 Li-Ion-Zelle (protected) | 1 | Passt in vorhandenes Akkufach des Boards |
| GM-Tube-Modul | RadiationD-v1.1 "CAJOE" mit J305-Röhre | 1 | Digitaler Pulsausgang, benötigt 5V |
| Display | 0,96" OLED SSD1306, I2C | 1 | 4-Pin (VCC, GND, SCL, SDA) |
| Sound | Piezo-Speaker (passiv) | 1 | Für authentischen Geiger-"Klick" |
| Treiber-Transistor | NPN, z.B. BC547/2N2222 | 1 | Als Puffer zwischen GPIO und Piezo |
| Basiswiderstand | ~1kΩ | 1 | Für Transistor-Basis |
| Verkabelung | Dupont-Kabel (m/f, m/m je nach Bedarf) | - | |
| Gehäuse | 3D-Druck, siehe [04-enclosure.md](04-enclosure.md) | 1 | |

## Bewusste Entscheidungen

- **Board-Wahl:** Bereits vorhandenes Wemos-Board mit eingebautem 18650-Akkufach + Lade-/Boost-Schaltung genutzt statt separater Komponenten – spart Platz im Gehäuse.
- **GM-Tube statt SBM-20 mit eigenem HV-Booster:** CAJOE-Board liefert HV-Erzeugung fertig integriert, geringerer Bastelaufwand, sehr verbreitet/gut dokumentiert.
- **Stromversorgung des GM-Tube-Moduls:** Läuft über den **5V-Ausgangspin** des Wemos-Boards (TP5400-Booster-Ausgang) – kein zusätzlicher Boost-Konverter nötig, da dieses Board-Modell einen sauberen 5V-Pin exponiert (verifiziert über Referenz-Pinout des Board-Designs).
- **Piezo statt echtem Lautsprecher:** authentischer Klick-Sound, minimaler Stromverbrauch (wichtig im Akkubetrieb), einfache Ansteuerung.
