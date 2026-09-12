# V2 – Quellen und verifizierte Daten

Stand: 2026-09-12.

## GC-1602-NANO

- Amazon-Bausatz: https://amzn.eu/d/0cK2H3rO
- Verkäuferangabe: 108 × 65 × 47 mm; Rohr 90 ±2 mm × 10 ±0,5 mm; empfohlene Arbeitsspannung 380 V
- GC-1602-Codebeispiel: https://github.com/WinHGGG/Geiger-Counter-v1.3-LCD-CAJOE
- CAJOE/RadiationD-Referenzprojekt: https://github.com/SensorsIot/Geiger-Counter-RadiationD-v1.1-CAJOE-

Der GC-1602-Beispielcode zählt FALLING-Flanken und verwendet `CPM/151`. IceGeiger übernimmt **nicht** blind den Faktor 151; CPM/Impulse bleiben Primärwerte, bis der tatsächlich gelieferte Röhrentyp verifiziert ist.

Die Verkäuferangabe „maximum counting rate 25 times/minute“ wird als unplausible/unklare Übersetzungsangabe **nicht für das Design verwendet**.

## Gelieferter Tracker

Auf der realen Platine steht `HITT-Tracker V1.2`; Rückseite: **SX1262** und **UC6580**. Verkäuferzeichnung: 65,84 × 28,00 mm, max. ca. 14,71 mm.

Öffentliche Heltec-V1.1-Unterlagen:

- https://resource.heltec.cn/download/Wireless_Tracker/Wireless%20Tracker1.1.pdf
- https://docs.heltec.org/en/node/esp32/wireless_tracker/hardware_update_log.html

Dort verifiziert: ESP32-S3FN8, SX1262, UC6580, Type-C, 3,7-V-Li-Akkuinterface, IPEX LoRa/GNSS, 0,96" 80×160 TFT, GPIO33/34 GNSS-UART und GPIO3 HIGH zur GNSS-Versorgung bei V1.1.

## Stromversorgung / Logging

- Pololu S13V10F5: https://www.pololu.com/product/4083/specs
- Joy-IT COM-MSD: https://joy-it.net/de/products/COM-MSD
- 2×18650 Parallelhalter: https://www.jf-elektronik.de/produkt/batteriehalter-2x-18650-parallel/
- 1S-BMS 4 A: https://funduinoshop.com/en/electronic-modules/other/voltage-regulator/lithium-battery-protection-board-charging-module-bms-1s-3.7-v-4a-for-18650-lipo-li-ion

## CAD-Referenz

Das bereitgestellte `GC-1602-NANO_CAJOE_1.1.stl` wurde lokal nur geometrisch untersucht. Bounding box: **119,05 × 71,00 × 28,80 mm**, geschlossenes Mesh. Es wird nicht in das Repository übernommen und nicht als Quelle für exakte PCB-Bohrungen behandelt.
