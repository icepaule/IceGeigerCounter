# V2 – Quellen und verifizierte Daten

Stand: 2026-09-14.

## GC-1602-NANO

- Amazon-Bausatz: https://amzn.eu/d/0cK2H3rO
- Verkäuferangabe: 108 × 65 × 47 mm; Rohr 90 ±2 mm × 10 ±0,5 mm; empfohlene Arbeitsspannung 380 V
- GC-1602-Codebeispiel: https://github.com/WinHGGG/Geiger-Counter-v1.3-LCD-CAJOE
- CAJOE/RadiationD-Referenzprojekt: https://github.com/SensorsIot/Geiger-Counter-RadiationD-v1.1-CAJOE-

Der GC-1602-Beispielcode zählt FALLING-Flanken und verwendet `CPM/151`. IceGeiger übernimmt **nicht** blind den Faktor 151; CPM/Impulse bleiben Primärwerte, bis der tatsächlich gelieferte Röhrentyp verifiziert ist.

Die Verkäuferangabe „maximum counting rate 25 times/minute“ wird als unplausible/unklare Übersetzungsangabe nicht für das Design verwendet.

## Gelieferter Tracker

Auf der realen Platine steht `HITT-Tracker V1.2`; Rückseite: **SX1262** und **UC6580**. Verkäuferzeichnung: 65,84 × 28,00 mm, max. ca. 14,71 mm.

Öffentliche Heltec-V1.1-Unterlagen:

- https://resource.heltec.cn/download/Wireless_Tracker/Wireless%20Tracker1.1.pdf
- https://docs.heltec.org/en/node/esp32/wireless_tracker/hardware_update_log.html

## Dual-18650 Battery Shield

Reales Modul mechanisch vermessen:

- **100,2 × 48,0 mm**
- unterseitiger Bauteilüberstand ca. **5 mm**
- HOLD/NORMAL-Schalter
- USB-/Lade-/Powerbank-artige Elektronik sichtbar

Öffentliche Vergleichsquellen für dieselbe/nahezu gleiche Shield-Familie:

- OKY3604-2 PDF: https://agelectronica.lat/pdfs/textos/O/OKY3604-2.PDF
- DFRobot-DFR0969-kompatible Beschreibung: https://www.bastelgarage.ch/arduino-1-60/accessories/2x18650-lithium-battery-shield-dfrobot-5v-2a-3-3v
- Community-Hinweis zu HOLD/NORMAL/Ruhestrom: https://forum.arduino.cc/t/2x18650-v8-battery-shield/1233901

Diese Quellen belegen die typische Funktionsklasse (5-V-Ausgang, Lade-/Schutzschaltung, HOLD/NORMAL). Da das reale Board ein Clone/eine unbekannte Revision sein kann, werden die elektrischen Eigenschaften im Projekt **nicht allein aus den Vergleichsquellen abgeleitet**, sondern vor Nutzung gemessen.

## Logging

- Joy-IT COM-MSD: https://joy-it.net/de/products/COM-MSD

## CAD-Referenz

Das bereitgestellte `GC-1602-NANO_CAJOE_1.1.stl` wurde lokal nur geometrisch untersucht. Bounding box: **119,05 × 71,00 × 28,80 mm**, geschlossenes Mesh. Es wird nicht in das Repository übernommen und nicht als Quelle für exakte PCB-Bohrungen behandelt.

Field Case v1.4 nutzt für das reale Battery Shield ausschließlich die vom Nutzer gemessenen Abmessungen; das Lochbild wird absichtlich vor Ort in massive 5-mm-Befestigungsschienen übertragen.
