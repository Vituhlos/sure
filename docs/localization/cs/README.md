# Česká lokalizace Sure

Tento adresář obsahuje závazné podklady a výsledky profesionální české
lokalizace webové, mobilní a desktopové aplikace Sure. Překlad vznikl po
funkčních celcích a prošel kontextovou, terminologickou i technickou kontrolou.

## Stav

- analýza repozitáře a lokalizační manuál: dokončeno;
- závazný glosář: 82/82 položek schváleno;
- Rails lokalizace: strukturálně úplná vůči angličtině;
- mobilní lokalizace: úplná vůči anglickému ARB katalogu;
- desktopová lokalizace: úplná vůči anglickému typovanému katalogu;
- kontextová a jazyková revize: dokončena;
- automatické testy a produkční build desktopu: dokončeny;
- referenční upstream commit: `5f0f5ec89d66beb04415e05853ef6930b0d46592`;
- referenční datum: 2. 8. 2026.

Čeština je v aplikaci zpřístupněna jako podporovaný jazyk. Nebyl vytvořen
commit ani nebyly změny odeslány na GitHub.

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
