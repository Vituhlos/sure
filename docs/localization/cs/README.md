# Česká lokalizace Sure

Tento adresář obsahuje závazné podklady a výsledky profesionální české
lokalizace webové, mobilní a desktopové aplikace Sure. Překlad vznikl po
funkčních celcích a prošel kontextovou, terminologickou i technickou kontrolou.

## Stav

- analýza repozitáře a lokalizační manuál: dokončeno;
- závazný glosář: 83/83 položek schváleno;
- Rails lokalizace: strukturálně úplná vůči angličtině;
- mobilní lokalizace: úplná vůči anglickému ARB katalogu;
- desktopová lokalizace: úplná vůči anglickému typovanému katalogu;
- kontextová a jazyková revize: dokončena;
- automatické Rails a Flutter testy a produkční build desktopu: dokončeny;
- auditovaná výchozí revize: `66ffc034b4ba2ce0bd3c23627b7edf75c504e91e`;
- verze Sure: `0.7.4-alpha.1`;
- referenční datum: 9. 9. 2026.

Čeština je v aplikaci zpřístupněna jako podporovaný jazyk. Opravy nezávislého
auditu jsou rozděleny do samostatných commitů na větvi
`feat/czech-localization`; stav odeslání na GitHub se ověřuje samostatně podle
aktuálního remotu.

## Dokumenty

- [STYLE_GUIDE.md](STYLE_GUIDE.md) — závazná jazyková, terminologická a
  typografická pravidla;
- [GLOSSARY.csv](GLOSSARY.csv) — schválená terminologie;
- [SOURCES.md](SOURCES.md) — autoritativní zdroje a jejich priorita;
- [DECISIONS.md](DECISIONS.md) — rozhodnutí s dopadem na více částí aplikace;
- [QA_REPORT.md](QA_REPORT.md) — souhrn automatických a jazykových kontrol;
- [UI_QA_MATRIX.md](UI_QA_MATRIX.md) — kontextové pokrytí funkčních celků.

Angličtina je jediným strukturálním zdrojem. Jiné lokalizace slouží pouze jako
pomůcka pro pochopení kontextu. Stabilní hodnoty API, názvy značek a
uživatelská data se nepřekládají.
