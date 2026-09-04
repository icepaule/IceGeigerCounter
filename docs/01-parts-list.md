# Stückliste

| Komponente | Modell | Menge | Bezugsquelle | Preis | Status |
|---|---|---|---|---|---|
| Mikrocontroller-Board | Wemos ESP-WROOM-02 mit 18650-Akkuhalterung (ESP8266EX, TP5400 Lade-/Boost-IC, AMS1117 3,3V-Regler, CP2102 USB-UART) | 1 | bereits vorhanden | – | Chip live verifiziert per `esptool`: ESP8266EX, 160MHz |
| Akku | 18650 Li-Ion-Zelle (protected) | 1 | bereits vorhanden | – | Passt in vorhandenes Akkufach des Boards |
| GM-Tube-Modul | **Entscheidung geändert:** selbstgebaute HV-Schaltung (555-Timer-Boost) statt Fertigmodul – siehe [06-hv-circuit.md](06-hv-circuit.md) | - | siehe [06-hv-circuit.md](06-hv-circuit.md) | ~5-6 € (Elektronik) + Röhre | ⚠️ Röhre (STS-6/SBM-20/J305) ohne verifizierten deutschen Händler, siehe Hinweis dort |
| Display | JOY-IT 0,96" OLED SSD1306, I2C | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/entwicklerboards_-_display_0_96_oled-display_ssd1306-266107) | 6,99 € | auf Lager, 1-2 Werktage |
| Sound | KY-006 Piezo-Speaker (passiv) | 1 | [az-delivery.de](https://www.az-delivery.de/products/buzzer-modul-passiv) | ca. 2,79–3,49 € | auf Lager |
| Treiber-Transistor | BC547B, NPN, TO-92 | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/bipolartransistor_npn_45v_0_1a_0_5w_to-92-5006) | 0,05 € | auf Lager, 1-2 Werktage |
| Basiswiderstand | Metallschicht 1,0 kΩ, 1W, 5% | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/widerstand_metallschicht_1_0_kohm_axial_1_w_5_-237109) | 0,68 € | auf Lager, 1-2 Werktage |
| Verkabelung | Dupont-Kabel (m/f, m/m je nach Bedarf) | - | vorhandenes Bastelmaterial | – | |
| Gehäuse | 3D-Druck, siehe [04-enclosure.md](04-enclosure.md) | 1 | – | – | |

## Hinweis zur GM-Tube-Lösung (aktualisiert)

Ursprünglich war das fertige CAJOE RadiationD-v1.1-Modul geplant, dafür gibt es aber **keinen deutschen Standarddistributor** (reichelt, exp-tech, az-delivery, berrybase, funduinoshop führen es nicht) und der einzige verifizierte deutsche Treffer ([42project.net](https://42project.net/shop/sensoren/geigerzaehler-geiger-mueller-zaehlrohr-gm-kernstrahlung-diy-modul-fuer-arduino-esp/)) war nicht lieferbar und zudem als Komplettpaket mit Zubehör (68,90€) vergleichsweise teuer.

**Entscheidung:** Stattdessen wird die Hochspannung selbst erzeugt (555-Timer-Boost-Schaltung), siehe [06-hv-circuit.md](06-hv-circuit.md) – mit vollständiger, aus dem Original-Schaltplan extrahierter Stückliste, größtenteils bei reichelt.de erhältlich. **Sicherheitshinweis dort unbedingt beachten (ca. 400V-Schaltung).**

## Bewusste Entscheidungen

- **Board-Wahl:** Bereits vorhandenes Wemos-Board mit eingebautem 18650-Akkufach + Lade-/Boost-Schaltung genutzt statt separater Komponenten – spart Platz im Gehäuse.
- **GM-Tube statt SBM-20 mit eigenem HV-Booster:** CAJOE-Board liefert HV-Erzeugung fertig integriert, geringerer Bastelaufwand, sehr verbreitet/gut dokumentiert.
- **Stromversorgung des GM-Tube-Moduls:** Läuft über den **5V-Ausgangspin** des Wemos-Boards (TP5400-Booster-Ausgang) – kein zusätzlicher Boost-Konverter nötig, da dieses Board-Modell einen sauberen 5V-Pin exponiert (verifiziert über Referenz-Pinout des Board-Designs).
- **Piezo statt echtem Lautsprecher:** authentischer Klick-Sound, minimaler Stromverbrauch (wichtig im Akkubetrieb), einfache Ansteuerung.
