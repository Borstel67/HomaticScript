# Lüftung: Temperatur-gesteuerter Boost (1x pro Kalendertag) + Dauerbetrieb Stufe 1

## Geräte / Datenpunkte
- Temperatursensor: `BidCos-RF.JEQ0058916:1.TEMPERATURE` (HM-WDS30-T-O)
- Lüftung (Stufe 1 / Relais): `BidCos-RF.SEQ3057205:1.STATE` (HM-LC-Sw4-DR-2 Kanal 1)

## Verhalten
- Wenn **Temperatur >= Schwellwert**: Lüftung **dauerhaft EIN** (Stufe 1).
- Wenn **Temperatur < Schwellwert**:
  - **Einmal pro Kalendertag**: Lüftung **2 Stunden EIN** (Boost)
  - Danach (und falls am selben Tag erneut unterschritten): Lüftung **AUS**
- Boost-Ende ist **nicht-blockierend** (separates Programm B).

## Systemvariablen (WebUI)
Anlegen unter: `Einstellungen → Systemvariablen`

1) `SV_LueftungBoostDatum`
- Typ: Zeichenkette (String)
- Inhalt: Datum `YYYY-MM-DD` (letzter Boost-Tag)

2) `SV_LueftungBoostBis`
- Typ: Zeichenkette (String)
- Inhalt: Zeitstempel `YYYY-MM-DD HH:MM:SS` (Boost-Ende), leer = kein Boost aktiv

## Programme (WebUI Schritt-für-Schritt)

### Programm A: Temperatur-Logik + Boost Start
Pfad: `Programme und Verknüpfungen → Programme und Zentralenverknüpfungen → Neu`

- Name: `Lüftung - Temp/Boost Start`

**Wenn…**
- Zeitsteuerung → Periodisch → alle **5 Minuten**

**Dann…**
- Aktivität hinzufügen → Skript
- Inhalt: `progA_lueftung_temp_boost_start_kalendertag.tcl`

Speichern: **OK**

### Programm B: Boost Ende → AUS
Pfad: `Programme und Verknüpfungen → Programme und Zentralenverknüpfungen → Neu`

- Name: `Lüftung - Boost Ende`

**Wenn…**
- Zeitsteuerung → Periodisch → alle **1 Minute**

**Dann…**
- Aktivität hinzufügen → Skript
- Inhalt: `progB_lueftung_boost_ende_aus.tcl`

Speichern: **OK**

## Dateien
- `progA_lueftung_temp_boost_start_kalendertag.tcl`
- `progB_lueftung_boost_ende_aus.tcl`