# Czech localization fix report

- **Audit baseline:** `66ffc034b4ba2ce0bd3c23627b7edf75c504e91e`
- **Sure version:** `0.7.4-alpha.1`
- **Implementation branch:** `feat/czech-localization`
- **Completed:** 9 September 2026

## Fixed issues

| ID | Status | Files | Resolution |
| --- | --- | --- | --- |
| C-01 | fixed | `mobile/lib/screens/main_navigation_screen.dart`, `mobile/lib/screens/sso_onboarding_screen.dart`, `mobile/lib/widgets/account_card.dart` | Lokalizační objekt má správný scope a runtime getter již není uvnitř neplatného `const` stromu. Původní tři Dart compile errors zmizely. |
| M-01 | fixed | `config/locales/views/recurring_transactions/cs.yml`, `test/lib/czech_pluralization_test.rb` | Větve `many` a `other` používají správné tvary „dne“ a „dní“; skutečný text je otestován pro 1, 2, 4, 5 a 21. |
| M-02 | partially fixed | `test/lib/czech_pluralization_test.rb`, `docs/localization/cs/STYLE_GUIDE.md`, `docs/localization/cs/DECISIONS.md` | Ověřeny Integer, Float a BigDecimal včetně 1.0, 1.1, 1.5, 2.0 a 5.0. Současný `format_quantity` odstraní koncovou nulu, takže plurál odpovídá viditelnému číslu. Obecný `Numeric` však neumí nést CLDR operand `v`; budoucí UI zachovávající koncovou nulu musí předat i tuto informaci. |
| M-03 | fixed | `config/locales/views/holdings/cs.yml`, `docs/localization/cs/GLOSSARY.csv` | `Book Value` je podle skutečného výpočtu `avg_cost × qty` přeloženo jako „Celková pořizovací hodnota“. |
| M-04 | fixed | `config/locales/models/assistant/cs.yml`, `docs/localization/cs/GLOSSARY.csv`, `docs/localization/cs/DECISIONS.md` | Obecný model `Depository` je „peněžní účet“; konkrétní podtypy si zachovávají přesnější názvy. |
| N-01 | fixed | české katalogy poskytovatelů, importů, transakcí, relací a nastavení | Všechny nalezené redundantní konstrukce s „úspěšně“ byly posouzeny podle kontextu, přeformulovány a u úplných vět byla sjednocena interpunkce. |
| N-02 | fixed | `config/locales/views/users/cs.yml` | Potvrzení po smazání identity zní „Uživatelský účet byl odstraněn.“ |
| N-03 | not changed | `docs/localization/cs/GLOSSARY.csv` | „Volná hotovost“ zůstává jako krátký a srozumitelný štítek investičního UI. Glosář vysvětluje význam a povoluje „volné peněžní prostředky“ v souvislém textu. |
| N-04 | fixed | `test/lib/czech_pluralization_test.rb` | Test prochází produkčním `format_quantity` a očekává české „1,5 jednotky“. |
| N-05 | not changed | `docs/localization/cs/STYLE_GUIDE.md`, `docs/localization/cs/DECISIONS.md` | Dotčené počty položek jsou celočíselné, takže `many` je za běhu nedosažitelná strukturální větev. Mechanická změna by nepřinesla produkční opravu; omezení je zdokumentováno. |
| N-06 | fixed | `docs/localization/cs/QA_REPORT.md`, `docs/localization/cs/UI_QA_MATRIX.md`, `docs/localization/cs/README.md` | Metriky a výsledky byly znovu změřeny nad opraveným stromem a historické tvrzení o neexistujících commitech bylo odstraněno. |
| H-01 | fixed | `app/views/accounts/_account.html.erb`, `config/locales/views/accounts/{en,cs}.yml` | Stav odstraňování účtu je v i18n; čeština používá „(probíhá odstraňování…)“. |
| H-02 | fixed | `app/views/pages/dashboard.html.erb`, `config/locales/views/pages/{en,cs}.yml` | Přístupný návod k řazení dashboardu je lokalizovaný a odpovídá ovladači Enter/mezerník, šipky a Escape. |
| H-03 | fixed | `app/helpers/application_helper.rb`, `app/views/layouts/shared/_htmldoc.html.erb` | Hlavní dokument používá dynamický BCP 47 jazykový tag. |
| H-04 | fixed | `app/helpers/application_helper.rb`, `app/views/layouts/print.html.erb` | Tiskový dokument používá dynamický BCP 47 jazykový tag. |
| H-05 | fixed | `app/views/layouts/doorkeeper/application.html.erb`, `app/views/doorkeeper/authorizations/new.html.erb`, `config/locales/doorkeeper/{en,cs}.yml` | OAuth layout má dynamický jazyk a nadpis, průběhové texty i bezpečnostní souhlas jsou kompletně v i18n. |
| H-06 | fixed | `app/views/invite_codes/_invite_code.html.erb`, `config/locales/views/invite_codes/{en,cs}.yml` | Obecné `Are you sure?` nahradilo konkrétní destruktivní potvrzení odstranění kódu. |
| H-07 | fixed | `app/views/mercury_items/setup_accounts.html.erb`, `app/views/lunchflow_items/setup_accounts.html.erb` | Titulky používají již existující lokalizované klíče bez duplikace katalogu. |

Nad rámec jednotlivých ID byly raw chyby v `ProcessPdfJob`,
`SsoProviderTester` a při převodu transakce na obchod odděleny od textu pro
uživatele. Třída a zkrácená zpráva výjimky zůstávají v `DebugLogEntry`.
Regresní testy ověřují PDF i SSO cestu. Dva zastaralé Flutter testy byly
uvedeny do souladu s lokalizačním kontraktem, aby mohl projít celý suite.

## Tests

Příkazy byly spuštěny nad aktuálním stromem; Rails a Flutter běžely v
izolovaných kopiích připojených pouze pro čtení k pracovnímu repozitáři.

### Rails

```text
bin/rails test test/lib/czech_pluralization_test.rb test/helpers/application_helper_test.rb test/integration/layout_accessibility_test.rb
```

Výsledek: 18 testů, 46 asercí, 0 selhání, 0 chyb, 0 přeskočeno.

```text
bin/rails test test/lib/czech_pluralization_test.rb test/jobs/process_pdf_job_test.rb test/models/sso_provider_tester_test.rb
```

Výsledek po doplnění P1: 13 testů, 73 asercí, 0 selhání, 0 chyb,
0 přeskočeno. Samostatné závěrečné PDF/SSO ověření: 11 testů, 59 asercí,
0 selhání, 0 chyb, 0 přeskočeno.

```text
bin/rails tailwindcss:build && bin/rails test
```

Výsledek: 6 127 testů, 24 390 asercí, 0 selhání, 0 chyb,
30 podmíněně přeskočeno.

```text
bin/rubocop
```

Výsledek: 2 185 souborů, 0 prohřešků.

### Flutter 3.32.4

```text
flutter analyze
```

Výsledek: původní tři lokalizační compile errors byly odstraněny. Příkaz
hlásí 7 nesouvisejících nálezů (6 `info`, 1 `warning`) a proto končí kódem 1;
jejich přesný seznam je v `docs/localization/cs/QA_REPORT.md`.

```text
flutter test test/l10n/czech_localization_test.dart
```

Výsledek: 6/6 testů prošlo.

```text
flutter test test/widgets/sure_button_test.dart test/services/auth_service_test.dart test/l10n/czech_localization_test.dart
```

Výsledek: 24/24 testů prošlo.

```text
flutter test --reporter compact
```

Výsledek: 189/189 testů prošlo.

### Desktop a statické kontroly

```text
cd desktop && npm run build
```

Výsledek: `tsc --noEmit` a Vite production build prošly; zpracováno
15 modulů.

```text
npx --yes @biomejs/biome@1.9.4 lint
```

Výsledek: passed, 0 prohřešků.

```text
git diff --check
```

Výsledek: passed, bez whitespace chyb.

Read-only strukturální audit načetl všechny YAML a ARB soubory a provedl
branch-aware porovnání klíčů a interpolací. Výsledek:

- 139 přímých EN/CS párů;
- 7 682/7 682 normalizovaných hodnot;
- 0 chybějících a 0 přebytečných klíčů;
- 0 neshod interpolací;
- 210/210 úplných českých pluralizačních skupin;
- 380/380 ARB zpráv a 0 neshod placeholderů;
- validní glosář s 83 datovými řádky a 8 sloupci;
- 0 zbývajících produkčních ERB výskytů hardcoded textů H-01 až H-07.

## Remaining risks

1. Obecná Rails plurální lambda nedokáže z `Numeric` zpětně zjistit viditelná
   desetinná místa. Současné UI koncovou nulu odstraní, takže jeho text je
   konzistentní; nový call-site zachovávající například `1,0` musí nést i
   informaci o viditelných desetinných místech.
2. `flutter analyze` má sedm existujících nelokalizačních nálezů uvedených
   výše. Žádný není compile error a celý Flutter suite prošel.
3. Nebyl proveden ruční vizuální průchod všech Rails a mobilních obrazovek na
   fyzickém zařízení. Automatické integrační a widget testy jsou zelené.

## Glossary changes

- `book value`: „účetní hodnota“ → „celková pořizovací hodnota“, protože
  call-site počítá `avg_cost × qty`;
- `depository account`: nová samostatná položka „peněžní účet“ pro široký
  model Sure;
- `bank account`: definice je omezena na účet skutečně vedený bankou;
- `payment`: obecný pojem je oddělen od speciálního `Transfer.payment?` a
  „úhrada“ je povolena v odpovídajícím kontextu;
- `market value`: definice nyní zahrnuje investiční výpočet množství krát
  aktuální tržní cena;
- `purchase price`: výchozí UI termín zůstává „pořizovací cena“, „kupní cena“
  je povolena ve smluvním nebo právním kontextu;
- `loan`: výchozí termín zůstává „úvěr“, „půjčka“ či „zápůjčka“ je povolena
  pouze podle skutečného produktu nebo vztahu;
- `brokerage cash`: „volná hotovost“ je ponechána pro krátký štítek a poznámka
  povoluje „volné peněžní prostředky“ v delším vysvětlení.

## Commits

- `1a79326be` — `fix(cs): repair localization runtime and hardcoded UI`
- `b7b29b30a` — `fix(cs): correct financial terminology and pluralization`
- `94b724033` — `fix(cs): keep raw diagnostics out of localized UI`
- `7a54bd300` — `refactor(cs): polish Czech UI language and glossary`
- `91612d908` — `test(cs): align mobile tests with localization contracts`
- dokumentační commit obsahující tento report —
  `docs(cs): refresh localization QA documentation` (jeho vlastní hash nelze
  vložit do obsahu commitu bez změny tohoto hashe; po vytvoření je to `HEAD`)

## Final repository state

Po vytvoření dokumentačního commitu a závěrečné kontrole `git status --short`
je pracovní strom čistý. Audit ani tento report netvrdí, že větev byla
odeslána na vzdálený repozitář; push je samostatný stav Git remotu.
