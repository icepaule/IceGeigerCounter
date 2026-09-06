# V2 – Zusammenbau Schritt für Schritt

## Phase A – GC-1602 allein

1. Bausatz auspacken und sichtbare Schäden prüfen.
2. Zählrohrbezeichnung fotografieren/notieren.
3. GC-1602 ausschließlich über die vorgesehene 5-V/USB-Versorgung starten.
4. LCD- und Klickfunktion prüfen.
5. Hintergrundzählung mindestens 10–15 Minuten beobachten.
6. Gerät ausschalten und einige Minuten warten, bevor an der Platine gearbeitet wird.

## Phase B – Maße

1. `hardware/v2/MEASURE_AFTER_DELIVERY.md` ausfüllen.
2. OpenSCAD-Parameter anpassen.
3. Fit-Jig rendern und drucken.
4. Passung prüfen.
5. Erst dann finale Gehäuseteile rendern.

## Phase C – Controller separat

1. Heltec Wireless Tracker V2 per USB-C flashen.
2. GNSS im Freien testen.
3. microSD anschließen und Schreibtest ausführen.
4. WLAN/MQTT testen.
5. LoRaWAN Join ohne GC-1602 testen.

## Phase D – INT-Schnittstelle

1. GC-1602 einschalten.
2. P3 `INT` gegen `GND` messen.
3. Pegelteiler 10 kΩ / 20 kΩ aufbauen.
4. Spannung am Mittelabgriff messen.
5. Nur wenn der Pegel für 3,3-V-GPIO sicher ist: Mittelabgriff an GPIO47.
6. GND gemeinsam verbinden.
7. Firmware-Pulszähler gegen GC-1602-LCD vergleichen.

## Phase E – Akkuversorgung

1. Zwei identische 18650 auf nahezu gleiche Spannung bringen.
2. 1S2P-Pack mit Schutz/BMS aufbauen bzw. fertigen geschützten Pack verwenden.
3. Pack ohne Last prüfen.
4. Heltec-Akkuversorgung anschließen.
5. 5-V-Boost einstellen und **vor** Anschluss des GC-1602 auf stabile 5,0 V prüfen.
6. GC-1602 anschließen.
7. Gesamtstrom messen und dokumentieren.

## Phase F – Gehäuse

1. Akkuhalter montieren.
2. Boost/BMS mechanisch isoliert befestigen.
3. Heltec mit GNSS-Antennenbereich nach oben/außen montieren.
4. microSD zugänglich montieren.
5. GC-1602 in der Messkammer befestigen.
6. Kabel gegen Zug und Scheuern sichern.
7. LoRa-Antenne montieren; nicht ohne geeignete Antenne mit hoher Leistung senden.
8. Deckel zunächst nur lose schließen und Funktionstest durchführen.

## Phase G – Funktionstest

Den vollständigen Testplan in `09-commissioning-test.md` abarbeiten.
