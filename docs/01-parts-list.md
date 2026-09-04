# Stückliste

| Komponente | Modell | Menge | Bezugsquelle | Preis | Status |
|---|---|---|---|---|---|
| Mikrocontroller-Board | Wemos ESP-WROOM-02 mit 18650-Akkuhalterung (ESP8266EX, TP5400 Lade-/Boost-IC, AMS1117 3,3V-Regler, CP2102 USB-UART) | 1 | bereits vorhanden | – | Chip live verifiziert per `esptool`: ESP8266EX, 160MHz |
| Akku | 18650 Li-Ion-Zelle (protected) | 1 | bereits vorhanden | – | Passt in vorhandenes Akkufach des Boards |
| GM-Tube-Modul | RadiationD-v1.1 "CAJOE" mit J305-Röhre | 1 | [42project.net](https://42project.net/shop/sensoren/geigerzaehler-geiger-mueller-zaehlrohr-gm-kernstrahlung-diy-modul-fuer-arduino-esp/) | 68,90 € | ⚠️ aktuell **nicht auf Lager**, siehe Hinweis unten |
| Display | JOY-IT 0,96" OLED SSD1306, I2C | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/entwicklerboards_-_display_0_96_oled-display_ssd1306-266107) | 6,99 € | auf Lager, 1-2 Werktage |
| Sound | KY-006 Piezo-Speaker (passiv) | 1 | [az-delivery.de](https://www.az-delivery.de/products/buzzer-modul-passiv) | ca. 2,79–3,49 € | auf Lager |
| Treiber-Transistor | BC547B, NPN, TO-92 | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/bipolartransistor_npn_45v_0_1a_0_5w_to-92-5006) | 0,05 € | auf Lager, 1-2 Werktage |
| Basiswiderstand | Metallschicht 1,0 kΩ, 1W, 5% | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/widerstand_metallschicht_1_0_kohm_axial_1_w_5_-237109) | 0,68 € | auf Lager, 1-2 Werktage |
| Verkabelung | Dupont-Kabel (m/f, m/m je nach Bedarf) | - | vorhandenes Bastelmaterial | – | |
| Gehäuse | 3D-Druck, siehe [04-enclosure.md](04-enclosure.md) | 1 | – | – | |

## Hinweis zum GM-Tube-Modul

Für das CAJOE RadiationD-v1.1-Modul (J305-Röhre) gibt es **keinen deutschen Standarddistributor** (reichelt, exp-tech, az-delivery, berrybase, funduinoshop führen es nicht). Einziger verifizierter deutscher Treffer ist [42project.net](https://42project.net/shop/sensoren/geigerzaehler-geiger-mueller-zaehlrohr-gm-kernstrahlung-diy-modul-fuer-arduino-esp/) – aktuell jedoch nicht lieferbar (Stand: Recherchedatum dieser Doku).

Alternativen (nicht einzeln verifiziert, da eBay/Amazon-Suchergebnisse für automatisierten Zugriff blockiert sind):
- Direkt bei 42project.net nach Liefertermin/Vorbestellung fragen
- eBay.de / Amazon.de nach "CAJOE Geiger Counter Kit" bzw. "RadiationD v1.1" durchsuchen (typische Preisspanne ca. 15–25 €, oft Versand aus der EU/China)

## Bewusste Entscheidungen

- **Board-Wahl:** Bereits vorhandenes Wemos-Board mit eingebautem 18650-Akkufach + Lade-/Boost-Schaltung genutzt statt separater Komponenten – spart Platz im Gehäuse.
- **GM-Tube statt SBM-20 mit eigenem HV-Booster:** CAJOE-Board liefert HV-Erzeugung fertig integriert, geringerer Bastelaufwand, sehr verbreitet/gut dokumentiert.
- **Stromversorgung des GM-Tube-Moduls:** Läuft über den **5V-Ausgangspin** des Wemos-Boards (TP5400-Booster-Ausgang) – kein zusätzlicher Boost-Konverter nötig, da dieses Board-Modell einen sauberen 5V-Pin exponiert (verifiziert über Referenz-Pinout des Board-Designs).
- **Piezo statt echtem Lautsprecher:** authentischer Klick-Sound, minimaler Stromverbrauch (wichtig im Akkubetrieb), einfache Ansteuerung.
