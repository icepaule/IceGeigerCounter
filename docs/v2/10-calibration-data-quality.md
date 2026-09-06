# V2 – Kalibrierung und Datenqualität

## CPM zuerst

Der GC-1602-Beispielcode verwendet häufig einen Faktor von `151 CPM = 1 µSv/h`. Dieser Wert darf **nicht automatisch als universelle Eigenschaft jedes mitgelieferten Zählrohrs verstanden werden**.

IceGeiger speichert deshalb:

- Rohimpulse pro 10 s,
- gleitende CPM,
- den konkret verwendeten Umrechnungsfaktor,
- den daraus berechneten µSv/h-Wert.

## Nach Lieferung

1. Aufdruck des Zählrohrs identifizieren.
2. Datenblatt/Herstellerangabe suchen.
3. Arbeitsspannungsbereich mit dem GC-1602 abgleichen.
4. dokumentierten CPM→Dosis-Faktor nur verwenden, wenn er für dieses Rohr und die relevante Strahlungsart plausibel ist.
5. Wenn möglich, Vergleich gegen ein bekanntes/kalibriertes Messgerät durchführen.

## Statistische Schwankung

Geigerzählung folgt näherungsweise Poisson-Statistik. Bei niedrigen Zählraten ist die relative Unsicherheit groß.

Beispiel: 20 CPM entsprechen in 10 s im Mittel nur 3,3 Impulsen. Ein einzelner 10-s-Punkt ist daher stark verrauscht.

Deshalb:

- 10-s-Rohwerte speichern,
- 60-s-CPM für Liveanzeige,
- Karten optional weiter mitteln.

## GNSS-Qualität

Positionen nur als hochwertig behandeln, wenn:

- `gps_valid=true`,
- plausibler HDOP,
- ausreichende Satellitenzahl,
- keine offensichtlichen Sprünge.

Die Bridge speichert Qualitätsfelder mit, damit später gefiltert werden kann.

## Keine Alarmgrenzen aus Hobbyhardware ableiten

Die V2-Anzeige kann Trends und auffällige Unterschiede sichtbar machen. Für behördliche Grenzwertentscheidungen oder Personendosimetrie ist ein nicht kalibriertes DIY-Gerät ungeeignet.
