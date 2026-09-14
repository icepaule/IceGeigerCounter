# V2 – BOM / Einkaufsliste

Stand: 2026-09-14. Aktueller mechanischer Aufbau: **Field Case v1.4** mit integriertem dualen 18650 Battery Shield.

## Bereits vorhanden / bestellt

| Pos. | Bauteil | Menge | Status / Spezifikation |
|---|---|---:|---|
| 1 | GC-1602-NANO Geiger Counter Kit inkl. Zählrohr | 1 | bestellt: https://amzn.eu/d/0cK2H3rO; Verkäufer nennt 108 × 65 × 47 mm |
| 2 | HITT/Heltec Wireless Tracker V1.2 | 1 | vorhanden; SX1262 + UC6580; 65,84 × 28,00 × 14,71 mm |
| 3 | Samsung INR18650-25R | 2 | vorhanden; wechselbare 18650 |
| 4 | Dual-18650 Battery Shield, HOLD/NORMAL | 1 | vorhanden; **real gemessen 100,2 × 48,0 mm**, unterseitiges Bauteil max. ca. 5 mm |

## Für den aktuellen v1.4-Aufbau noch zu beschaffen

| Pos. | Bauteil | Menge | Festlegung / Zweck |
|---|---|---:|---|
| 5 | Joy-IT COM-MSD oder dimensionsgleiches 3,3-V-SPI-microSD-Modul | 1 | Designhülle 21 × 18 × 12 mm |
| 6 | microSD-Karte | 1 | 16–32 GB High-Endurance/Industrial bevorzugt |
| 7 | Widerstand 10 kΩ, 1 % | 1 | GC-INT-Pegelteiler oben |
| 8 | Widerstand 20 kΩ, 1 % | 1 | GC-INT-Pegelteiler unten |
| 9 | abgedichteter M12-Schalter | 1 | optionaler Hauptschalter; Gehäuseöffnung vorhanden |
| 10 | U.FL/IPEX → SMA-Female Bulkhead | 1 | 5–10 cm, 50 Ω; LoRa-Antenne außen |
| 11 | 868-MHz-SMA-Antenne | 1 | ca. 2 dBi; EU868 |
| 12 | 2-mm-Silikon-Rundschnur | ~0,7 m | Hauptgehäusedichtung |
| 13 | 1-mm-Polycarbonat | 2 Fenster | von innen für beide Displays |
| 14 | PET/Mylar-Folie 25–50 µm | 1 Stück | Beta-Membran vor dem Zählrohr |
| 15 | M3 Heat-Set Inserts | 10–12 | Hauptdeckel + Beta-Kappe |
| 16 | M3×8/M3×10 Edelstahl | 10–12 | Gehäuseverschraubung |
| 17 | PETG oder ASA | ~350–500 g | Base/Lid/Service-Bridge/Beta-Kappe |

## Battery Shield – verifizierter und noch zu prüfender Stand

Das vorhandene Board entspricht mechanisch und optisch der verbreiteten dualen 18650-Powerbank-Shield-Familie (DFR0969/OKY3604-2-artig): HOLD/NORMAL-Schalter, Ladeeingang, USB-Ausgang und 5-V/3,3-V-Ausgänge.

**Mechanisch verifiziert am realen Board:** 100,2 × 48,0 mm und ca. 5 mm Bauteilüberstand auf der Unterseite.

**Vor der endgültigen elektrischen Verdrahtung prüfen:**

1. Zellpolarität an beiden Haltern.
2. beide 18650 vor Parallelschaltung auf nahezu gleiche Spannung bringen.
3. Ausgang 5 V mit Multimeter ohne Last und unter Last messen.
4. NORMAL/HOLD-Verhalten testen.
5. Ladefunktion und Abschalt-/Schutzverhalten verifizieren.
6. Ruhestrom in HOLD messen; einige Shield-Revisionen halten die Powerbank über einen Dummy-Load aktiv und können dadurch unnötig Energie verheizen.

Wenn das reale Shield die erwarteten 5 V stabil liefert, kann der GC-1602 direkt aus dessen 5-V-Schiene versorgt werden. Der Tracker kann je nach verifiziertem Power-Path über die geeignete Shield-Schiene bzw. seinen Batterieeingang versorgt werden.

Ein separater BMS + Pololu-Boost aus Field Case v1.2 ist **nicht mehr mechanischer Bestandteil von v1.4**, bleibt aber als Fallback-Architektur möglich, falls das reale Battery Shield beim Last-/Ruhestromtest ungeeignet ist.

## LoRaWAN-Infrastruktur

Für privaten ChirpStack-Betrieb wird ein echtes EU868-Multichannel-Gateway benötigt (SX1302/SX1303 oder vergleichbarer Concentrator). Ein SX1262-Endgerät ist kein Gateway.
