# V2 – Zusammenbau Schritt für Schritt

## Phase A – GC-1602 allein

1. Bausatz auspacken und sichtbare Schäden prüfen.
2. Zählrohrbezeichnung fotografieren/notieren.
3. GC-1602 ausschließlich über die vorgesehene 5-V/USB-Versorgung starten.
4. LCD- und Klickfunktion prüfen.
5. Hintergrundzählung mindestens 10–15 Minuten beobachten.
6. Gerät ausschalten und einige Minuten warten, bevor an der Platine gearbeitet wird.

## Phase B – Gehäuse/Passprobe v1.4

1. zuerst `icegeiger_field_case_v14_gasket_jig.stl` drucken und 2-mm-Silikonrundschnur prüfen.
2. danach `base`, `service_bridge` und `lid` drucken.
3. Battery Shield **ohne Zellen** auf die 5×5-mm-Schienen setzen.
4. reales Shield-Lochbild auf die Schienen übertragen und Pilotlöcher bohren.
5. GC-1602 trocken auf die breiten Eckpads legen und sein reales Lochbild markieren/bohren.
6. Tracker und microSD auf der Service-Brücke trocken montieren.
7. Deckel zunächst ohne Dichtung schließen und Kollisionen prüfen.

## Phase C – Controller separat

1. HITT-Tracker V1.2 per USB-C flashen.
2. GNSS im Freien testen.
3. microSD anschließen und Schreibtest ausführen.
4. WLAN/MQTT testen.
5. LoRaWAN Join ohne GC-1602 testen.

## Phase D – INT-Schnittstelle

Ausführliche Schritt-für-Schritt-Anleitung mit Verdrahtungsdiagramm, Wartezeiten und Messprotokoll: [08a-phase-d-int-schnittstelle.md](08a-phase-d-int-schnittstelle.md).

1. GC-1602 einschalten.
2. P3 `INT` gegen `GND` messen.
3. Pegelteiler 10 kΩ / 20 kΩ aufbauen.
4. Spannung am Mittelabgriff messen.
5. nur wenn der Pegel für 3,3-V-GPIO sicher ist: Mittelabgriff an **GPIO17**.
6. GND gemeinsam verbinden.
7. Firmware-Pulszähler gegen GC-1602-LCD vergleichen.

## Phase E – Battery Shield

1. beide INR18650-25R einzeln auf Spannung und Zustand prüfen.
2. nur Zellen mit nahezu gleicher Spannung gemeinsam einsetzen.
3. Polarität jedes Schachtes kontrollieren.
4. Shield allein einschalten.
5. 5-V-Ausgang ohne Last messen.
6. definierte Testlast anschließen; Spannung, Strom und Temperatur messen.
7. NORMAL und HOLD testen.
8. Ruhestrom in HOLD messen.
9. Ladefunktion mit geeignetem USB-Netzteil testen.
10. erst danach IceGeiger an das Shield anschließen.

Einige Shields dieser Powerbank-Familie nutzen im HOLD-Modus eine Zusatzlast, um das Auto-Off zu verhindern. Deshalb ist der Ruhestromtest Pflicht, insbesondere vor dem Dauerbetrieb im Schuppen.

## Phase F – Gehäuse

1. Battery Shield auf den gebohrten kurzen Befestigungsschienen montieren.
2. Tracker-/microSD-Service-Brücke montieren.
3. Tracker so einsetzen, dass Pinreihen in den offenen Schlitzen frei bleiben.
4. GNSS-Patchbereich nicht mit Metall, Kabelbündeln oder Akkuclips abdecken.
5. GC-1602 befestigen.
6. Kabel gegen Zug und Scheuern sichern.
7. U.FL→SMA-Pigtail montieren.
8. Beta-Membran und Schutzkappe montieren.
9. Polycarbonat-Displayfenster einkleben.
10. Dichtung einsetzen und Deckel gleichmäßig über acht M3-Schrauben anziehen.

## Phase G – Funktionstest

Den vollständigen Testplan in `09-commissioning-test.md` abarbeiten.
