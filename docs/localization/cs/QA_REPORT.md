# Zpráva o kvalitě české lokalizace

- **Stav:** opravy auditu dokončeny a otestovány
- **Auditovaná výchozí revize:** `66ffc034b4ba2ce0bd3c23627b7edf75c504e91e`
- **Verze Sure:** `0.7.4-alpha.1`
- **Poslední aktualizace:** 9. 9. 2026

Kontrola zahrnuje Rails aplikaci, mobilní Flutter klient a desktopový Tauri
klient. Význam překladu byl ověřován proti skutečným call-site; angličtina je
strukturálním zdrojem pro párové katalogy.

## Výsledek

- 139 přímých párů `en.yml`/`cs.yml` má shodnou normalizovanou strukturu;
- další dva české datové katalogy obsahují názvy měn a časových pásem, takže
  repozitář obsahuje celkem 141 souborů `cs.yml`;
- přímé páry obsahují 7 682/7 682 normalizovaných aplikačních hodnot;
- nebyl nalezen žádný chybějící ani neočekávaný český klíč v přímých párech;
- nebyla nalezena žádná skutečná neshoda interpolací;
- všech 210 českých pluralizačních skupin obsahuje větve
  `one/few/many/other`;
- mobilní katalogy mají shodně 380 zpráv a shodné placeholdery;
- desktopový katalog zůstává typově vynucen a produkční build prošel;
- všech 83 položek glosáře je po kontextové kontrole schváleno.

Normalizovaná hodnota znamená jeden logický překladový klíč; plurální větve
se při tomto počtu považují za jednu skupinu. Dva samostatné datové katalogy
nemají sourozenecký `en.yml`, proto se nezapočítávají do počtu přímých párů.

## Automatické kontroly

| Kontrola | Výsledek |
| --- | --- |
| Načtení všech locale YAML | passed — 0 chyb syntaxe |
| Validita `GLOSSARY.csv` | passed — 83 řádků, 8 sloupců |
| Shoda normalizovaných Rails klíčů | passed — 7 682/7 682, 0 chybějících, 0 přebytečných |
| Shoda interpolací Rails | passed — 0 skutečných neshod |
| České plurály `one/few/many/other` | passed — 210/210 skupin |
| Mobilní ARB zprávy a placeholdery | passed — 380/380, 0 neshod |
| Cílená česká lokalizace Flutter | passed — 6/6 testů |
| Celý Flutter suite | passed — 189/189 testů |
| Celý Rails test suite | passed — 6 127 testů, 24 390 asercí, 0 selhání, 0 chyb, 30 přeskočeno |
| RuboCop | passed — 2 185 souborů, 0 prohřešků |
| Biome lint | passed — 0 prohřešků |
| Desktop `tsc --noEmit && vite build` | passed — 15 modulů |
| Hardcoded nálezy z auditu | passed — 0 zbývajících výskytů v produkčních ERB |
| `git diff --check` | passed — bez chyb whitespace |

Plný Rails suite běžel v izolovaném PostgreSQL a Redis. Podmíněně přeskočené
testy jsou součást upstream suite; běh neobsahoval chybu ani selhání. Flutter
testy a analyzátor používaly projektovou verzi Flutter 3.32.4 v kontejneru.

## Flutter analyze

`flutter analyze` již nehlásí žádnou ze tří lokalizačních kompilačních chyb
z C-01. Příkaz končí nenulově kvůli sedmi existujícím nálezům mimo českou
lokalizaci:

- dvě doporučení `prefer_const_constructors`;
- zastaralé `dart:html` a `avoid_web_libraries_in_flutter` ve webovém stubu;
- jeden zbytečný escape ve webovém stubu;
- jedno `use_build_context_synchronously` ve formuláři transakce;
- jedna nepoužitá proměnná `failedCount` ve službě transakcí.

Jde o šest informací a jedno varování, nikoli o Dart compile errors. Nebyly
měněny, protože nesouvisejí s opravami české lokalizace; celý Flutter test
suite se přesto zkompiloval a prošel.

## Ověřené opravy auditu

- mobilní lokalizační objekty mají správný scope a runtime text není v
  `const` stromu;
- `expected_in` používá správné tvary pro 1, 2, 4, 5 a 21 dní;
- HTML dokumenty používají jazykový tag odvozený z aktivního locale;
- OAuth souhlas, destruktivní potvrzení, stav odstraňování účtu, přístupný
  návod dashboardu a titulky poskytovatelů jsou v i18n;
- „Book Value“ odpovídá skutečnému výpočtu jako „Celková pořizovací hodnota“;
- obecný `Depository account` je „peněžní účet“;
- raw technické chyby PDF, SSO a převodu na obchod zůstávají v
  `DebugLogEntry`, nikoli v uživatelském textu;
- české potvrzovací zprávy byly kontextově zbaveny redundantního
  „úspěšně“ a sjednoceny interpunkčně;
- odstranění uživatele výslovně uvádí „Uživatelský účet“.

## Omezení

Nebyla provedena ruční vizuální kontrola na fyzickém telefonu ani úplný
průchod všemi obrazovkami v běžícím prohlížeči. Automatické Rails integrační
testy, Flutter widget/unit testy a statické kontroly však prošly. Obecná Rails
pluralizace stále nemůže z pouhého `Numeric` rekonstruovat původně viditelnou
koncovou nulu; současný produkční `format_quantity` ji nezobrazuje a testované
tvary proto odpovídají skutečnému UI. Podrobnost zachycuje D-030.
