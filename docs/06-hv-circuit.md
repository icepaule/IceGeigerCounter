# Selbstgebaute Hochspannungsschaltung (HV-Generator)

## ⚠️ Sicherheitshinweis – zuerst lesen

Diese Schaltung erzeugt intern **ca. 400 V Gleichspannung** zur Versorgung der Geiger-Müller-Röhre.

- **Niemals** an Schaltungsteile fassen, während die Schaltung an Spannung liegt.
- Vor jeder Berührung/Messung/Umbau: Spannungsquelle trennen **und** den Speicherkondensator (C4) aktiv entladen (z.B. über einen Widerstand ~100 kΩ, nicht direkt kurzschließen).
- Mit einer Hand arbeiten, wenn an der Schaltung unter Spannung gemessen wird (keine Erdungsschleife über den Körper).
- Kein Aufbau auf offenem, ungeschütztem Steckbrett im laufenden Betrieb in Reichweite von Kindern/Haustieren.
- Diese Anleitung stellt eine **verifizierte Stückliste** bereit, aber **keine handgezeichnete Verdrahtungsanleitung** für diesen Teil – bei mehreren hundert Volt ist das Risiko eines Übertragungsfehlers zu hoch. Vor dem Löten **zwingend das Original-Schaltbild** in KiCad (kostenlos) öffnen und gegenprüfen, siehe unten.

## Herkunft der Schaltung

- Software-/Hardwareprojekt: [grillbaer/esp32-geiger-counter](https://github.com/grillbaer/esp32-geiger-counter)
- Schaltplan (KiCad, Original-Quelle): [`geiger.sch`](https://github.com/grillbaer/esp32-geiger-counter/blob/master/hardware/kicad/project/geiger/geiger.sch)
- Ursprüngliches HV-Konzept: 555-Timer-Boost-Wandler nach "ArnoR", diskutiert in [mikrocontroller.net-Forum: Hochspannungserzeugung Geigerzähler aus 3V](https://www.mikrocontroller.net/topic/380666)
- Funktionsprinzip (Kurzfassung aus dem Forum): 555-Timer schaltet einen Transistor, der die Speicherdrossel (L1) auflädt. Beim Abschalten wird die gespeicherte Energie in einen Hochspannungspuls umgesetzt; ein Stromfühlerwiderstand in der Emitterleitung des Schalttransistors begrenzt/regelt die Spannung über den Reset-Eingang des 555-Timers.

**Portierbarkeit auf ESP8266:** Die Pulserfassung läuft über einen normalen GPIO-Interrupt (kein ESP32-spezifisches Feature), I2C fürs Display ist identisch. Nur eventueller Deep-Sleep-Code müsste von ESP-IDF-Aufrufen auf die ESP8266-Arduino-API umgestellt werden – für dieses Projekt ohnehin nicht vorgesehen (WLAN/MQTT bleibt aktiv).

## Stückliste (aus dem Original-Schaltplan extrahiert)

| Ref. | Bauteil | Wert | Menge | Bezugsquelle | Preis/Stk. | Status |
|---|---|---|---|---|---|---|
| U2, U3 | Timer-IC TLC555, DIP-8 (CMOS, low power) | TLC555CP | 2 | [de.farnell.com](https://de.farnell.com/texas-instruments/tlc555cp/ic-timer-cmos-dip8-555/dp/3006913) | – | reichelt führt nur SOIC-8 (SMD) oder bipolares NE555 DIP-8; **Alternative:** NE555 (DIP-8, [reichelt.de](https://www.reichelt.com/de/en/timer-dip-8-ne-555-tex-p13397.html), 0,29€) funktioniert elektrisch, zieht aber mehr Ruhestrom (bei 18650-Akku unkritisch) |
| Q1 | Transistor BC328, PNP, TO-92 | BC328 | 1 | reichelt.de (Standardartikel, nach "BC328" suchen) | ~0,10€ | Standardbauteil |
| Q2 | Transistor MPSA44, NPN, 400V, TO-92 | MPSA44 | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/bipolartransistor_npn_400v_0_3a_0_625w_to-92-13114) | 0,09€ | auf Lager |
| Q3 | Transistor BC517, NPN-Darlington, TO-92 | BC517 | 1 | reichelt.de (Standardartikel, nach "BC517" suchen) | ~0,10€ | Standardbauteil |
| D1 | Diode, schnell, 600V | MUR160 | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/gleichrichterdiode_600_v_1_a_do-41-219516) | 0,11€ | auf Lager |
| D2, D3 | Z-Diode, 200V, 2W (in Serie ≈ 400V) | ZY200 | 2 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/zenerdiode_200_v_2_w_do-41-219675) | 0,15€ | auf Lager |
| D4 | Diode, Kleinsignal | 1N4148 | 1 | reichelt.de (Standardartikel) | ~0,05€ | Standardbauteil |
| D5 | Z-Diode, 3,3V (Schutz Pulsausgang) | Zener 3V3 | 1 | reichelt.de (Standardartikel) | ~0,10€ | Standardbauteil |
| L1 | Speicherdrossel, bedrahtet | 10 mH | 1 | [reichelt.de](https://www.reichelt.de/de/de/shop/produkt/stehende_induktivitaet_09p_10mh-1113) | 0,60€ | ⚠️ laut Reichelt erst ab 30.11.2026 lieferbar – Alternative bei RS Components/Farnell suchen (Zugriff dort automatisiert blockiert, bitte selbst prüfen) oder auf Restock warten |
| R1, R2, R3 | Widerstand 0,25W | 1,8 MΩ | 3 | reichelt.de (Standardartikel) | ~0,05€ | Standardbauteil |
| R4 | Widerstand 0,25W | 1,5 kΩ | 1 | reichelt.de | ~0,05€ | Standardbauteil |
| R5, R9 | Widerstand 0,25W | 100 kΩ | 2 | reichelt.de | ~0,05€ | Standardbauteil |
| R6, R10 | Widerstand 0,25W | 10 kΩ | 2 | reichelt.de | ~0,05€ | Standardbauteil |
| R7 | Widerstand 0,25W | 15 Ω | 1 | reichelt.de | ~0,05€ | Standardbauteil |
| R8 | Widerstand 0,25W | 220 kΩ | 1 | reichelt.de | ~0,05€ | Standardbauteil |
| R11 | Widerstand 0,25W | 3,9 kΩ | 1 | reichelt.de | ~0,05€ | Standardbauteil |
| R12 | Widerstand 0,25W | 3,3 kΩ | 1 | reichelt.de | ~0,05€ | Standardbauteil |
| R13 | Widerstand 0,25W | 4,7 kΩ | 1 | reichelt.de | ~0,05€ | Standardbauteil |
| C1 | Kondensator, Folie/Keramik | 47 nF | 1 | reichelt.de | ~0,10€ | Standardbauteil |
| C2, C3, C5, C6, C7, C8 | Kondensator, Keramik | 100 nF | 6 | reichelt.de | ~0,10€ | Standardbauteil |
| C4 | Elko, radial | 100 µF | 1 | reichelt.de | ~0,15€ | Standardbauteil |
| C9 | Elko, radial | 1000 µF | 1 | reichelt.de | ~0,25€ | Standardbauteil, Eingangspufferung |
| V1 | Geiger-Müller-Zählrohr | STS-6 (oder kompatibel: SBM-20, J305) | 1 | **kein verifizierter deutscher Händler gefunden** | – | siehe Hinweis unten |

## Hinweis zur Röhre (V1)

Für eine **rohe** GM-Röhre (STS-6/SBM-20/J305, ohne fertige Treiberelektronik) konnte ich **keinen verifizierten deutschen oder EU-Händler** bestätigen:
- `sensorbay.eu` taucht in Suchergebnissen auf, die Domain ist aber **nicht auflösbar** (NXDOMAIN, mehrfach über verschiedene DNS-Server geprüft) – vermutlich nicht mehr aktiv, **nicht verwenden**.
- eBay.de listet SBM-20/SBM 20-1 (z.B. für ~38,90€), automatisierter Zugriff wird dort blockiert (403) – bitte selbst prüfen und Verkäuferstandort/Bewertungen kontrollieren.
- `soviet-tubes.com` und `rhelectronics.store` bieten SBM-20 international an, Versandland/-dauer selbst prüfen.

## Vor dem Aufbau

1. Schaltplan [`geiger.sch`](https://github.com/grillbaer/esp32-geiger-counter/blob/master/hardware/kicad/project/geiger/geiger.sch) mit kostenlosem [KiCad](https://www.kicad.org/) öffnen und Bauteil-für-Bauteil mit der Stückliste oben abgleichen.
2. Aufbau auf Lochrasterplatine (kein offenes Steckbrett für den HV-Teil) mit ausreichend Kriechstrecke zwischen den 400V-führenden Leiterbahnen.
3. Nach Aufbau: Vor Anschluss der Röhre die HV-Ausgangsspannung mit einem Multimeter (Tastkopf für Hochspannung, min. 600V-Bereich) prüfen, ob sie im erwarteten Bereich (~350–400V) liegt.
4. Pulsausgang (entspricht "Pulse Out" / J1 im Original-Schaltplan) wird wie ursprünglich für das CAJOE-Modul geplant an **D7 / GPIO13** des Wemos-Boards angeschlossen (siehe [02-wiring.md](02-wiring.md)).
