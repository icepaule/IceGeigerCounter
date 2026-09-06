# Maße nach Lieferung — Pflicht vor FINAL-STL

Mit Messschieber aufnehmen und hier eintragen:

- [ ] GC-1602 PCB Länge / Breite / Dicke
- [ ] vier Befestigungsbohrungen: Durchmesser und X/Y-Abstände
- [ ] Gesamtbauhöhe unten/oben
- [ ] LCD-Außenmaß und sichtbare Displayfläche, X/Y relativ zum PCB
- [ ] Arduino-Nano-USB-Überstand und Buchsenhöhe
- [ ] P3 GND/5V/INT Position und Steckerhöhe
- [ ] Schalter S1, Audio-/Versorgungsbuchsen: Position und notwendiger Zugang
- [ ] tatsächliches Zählrohr: Typ, Länge, Durchmesser, Lage unter/auf PCB
- [ ] Heltec Wireless Tracker V2: Boardrevision, L/B/H, Antennen-/USB-C-Lage
- [ ] microSD-Modul L/B/H und Karten-Auszug
- [ ] beide 18650: tatsächlicher Durchmesser/Länge (protected Zellen oft länger)
- [ ] BMS und 5-V-Boost L/B/H

Danach Werte am Kopf von `openscad/icegeiger_v2_enclosure.scad` ersetzen, `scripts/build-stl.sh` ausführen, zuerst Fit-Jig drucken und Passung prüfen. Erst danach FINAL-STLs erzeugen/benennen.
