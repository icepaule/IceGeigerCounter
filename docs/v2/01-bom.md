# V2 – BOM / Einkaufsliste

## Bereits gekauft

| Pos. | Bauteil | Menge | Status / Quelle | Bemerkung |
|---|---|---:|---|---|
| 1 | GC-1602-NANO Geiger Counter Kit inkl. Zählrohr | 1 | gekauft: https://amzn.eu/d/0cK2H3rO | tatsächliche Röhrenbezeichnung nach Lieferung prüfen |

## Kernkomponenten

| Pos. | Bauteil | Menge | Mindestanforderung | Zweck |
|---|---|---:|---|---|
| 2 | Heltec Wireless Tracker V2, EU868 | 1 | ESP32-S3 + SX1262 + UC6580 | WLAN, LoRaWAN, GNSS, Hauptcontroller |
| 3 | microSD SPI Breakout | 1 | 3,3-V-Logik, kurze Leitungen | Offline-Logger |
| 4 | microSD-Karte | 1 | 8–32 GB, Industrial/High Endurance bevorzugt | Messdatenspeicher |
| 5 | Widerstand 10 kΩ | 1 | 1 %, 0,125 W oder größer | INT-Pegelteiler oben |
| 6 | Widerstand 20 kΩ | 1 | 1 %, 0,125 W oder größer | INT-Pegelteiler unten |
| 7 | 18650 Li-Ion | 2 | identisches Modell, identisches Alter, gleiche Kapazität; protected bevorzugt | 1S2P-Akku |
| 8 | 2×18650-Halter bzw. 1S2P-Pack | 1 | mechanisch stabil | Akkuaufnahme |
| 9 | 1S-Schutz/BMS | 1 | für parallele 1S-Zellen, Stromreserve >= 2 A | Schutz gegen Über-/Unterspannung/Kurzschluss |
| 10 | 5-V-Boost-Wandler | 1 | 3–4,2 V Eingang, 5 V stabil, >= 1 A | Versorgung des GC-1602 |
| 11 | Hauptschalter | 1 | >= 2 A DC | Gesamtgerät ein/aus |
| 12 | Feinsicherung / PTC | 1 | passend zum Akkupack | zusätzliche Akkusicherung |
| 13 | JST/SH1.25-Stecker passend zum Heltec | 1 | passend zum Board | Akkuanschluss Heltec |

## Mechanik

| Pos. | Bauteil | Menge | Empfehlung |
|---|---|---:|---|
| 14 | M3×8 Schrauben | 8–12 | Gehäusedeckel / Halter |
| 15 | M3 Messing-Gewindeeinsätze | 8–12 | Heat-set, Außendurchmesser ca. 4,6 mm |
| 16 | M2.5 Schrauben | nach Messung | ggf. für Elektronikhalter |
| 17 | TPU-/Schaumstreifen | wenige cm | Zählrohr/PCB vibrationsarm lagern |
| 18 | PLA/PETG/ASA | ca. 250–350 g | PETG für Schuppen/Auto thermisch robuster als PLA |

## Optional: LoRaWAN-Infrastruktur

Für einen privaten ChirpStack-Pfad wird mindestens **ein echtes Multi-Channel-LoRaWAN-Gateway** benötigt.

Anforderung:

- EU868,
- SX1302/SX1303 oder vergleichbarer LoRaWAN-Concentrator,
- mindestens 8 Kanäle,
- Ethernet bevorzugt,
- Basic Station oder Semtech UDP / ChirpStack Gateway Bridge.

Ein einzelnes SX1262/SX1276-Endgeräte-Modul ist **kein vollwertiges LoRaWAN-Gateway**.

## Nicht bewusst festgelegt

Die folgenden Punkte werden erst nach Lieferung des realen GC-1602 endgültig festgelegt:

- Zählrohrtyp und damit Kalibrierfaktor,
- genaue PCB-Abmessungen und Befestigungspunkte,
- endgültige Position der LCD-Aussparung,
- endgültige Akkuzellenlänge (geschützt/unprotected),
- endgültige 5-V-Stromaufnahme des GC-1602.
