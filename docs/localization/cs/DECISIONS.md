# Rozhodnutí české lokalizace

- **Stav dokumentu:** schválený závazný základ
- **Poslední revize:** 2. 8. 2026

Tento log zachycuje rozhodnutí, která mají dopad na více řetězců, technickou
úplnost nebo význam finančních funkcí. Jednorázová samozřejmá jazyková oprava
sem nepatří.

Stavy:

- `proposed` — návrh čeká na schválení;
- `approved` — závazné rozhodnutí;
- `superseded` — nahrazeno novějším rozhodnutím;
- `needs-context` — rozhodnutí čeká na ověření v aplikaci nebo kódu.

Souhrnný rámec rozhodnutí D-001 až D-019 byl 28. 7. 2026 schválen pro zahájení
překladu. Stav jednotlivých rozhodnutí se mění na `approved` po ověření v
prvním dotčeném funkčním celku; toto průběžné potvrzení brání tomu, aby obecné
pravidlo převážilo nad později nalezeným konkrétním kontextem.

## D-001 — Vykání a neutrální oslovování

- **Stav:** approved
- **Rozhodnutí:** Sure uživateli vyká druhou osobou množného čísla. Zájmena
  `vy`, `vám` a `váš` se uvnitř věty píší s malým písmenem. Neznámý rod se
  řeší neutrální větnou stavbou, nikoli lomítkem.
- **Důvod:** Jde o přirozený profesionální standard českého finančního
  rozhraní a doporučení českých příruček Mozilly a Microsoftu.
- **Zdroje:** [MOZ-CS], [MS-CS]

## D-002 — Infinitiv na akčních tlačítkách

- **Stav:** approved
- **Rozhodnutí:** Krátké popisky akcí používají infinitiv: „Uložit“, „Přidat
  účet“, „Zkusit znovu“. Pokyn ve větě používá zdvořilý rozkaz.
- **Důvod:** Infinitiv je stručný, rodově neutrální a v českých rozhraních
  ustálený.
- **Zdroje:** [MOZ-CS], [MS-CS]

## D-003 — Větné psaní velkých písmen

- **Stav:** approved
- **Rozhodnutí:** Nadpisy, nabídky a tlačítka používají větné psaní velkých
  písmen. Anglické Title Case se nepřenáší.
- **Důvod:** Odpovídá českému pravopisu a snižuje vizuální i jazykovou
  strojenost.
- **Zdroje:** [UJC], [MOZ-CS], [MS-CS]

## D-004 — Neznámý rod dynamických objektů

- **Stav:** approved
- **Rozhodnutí:** Pokud klíč interpoluje název objektu neznámého rodu,
  přestaví se věta, například „Odstraněno: %{name}.“ Rodová shoda se použije
  jen u objektu, jehož typ je zaručený konkrétním klíčem.
- **Důvod:** Varianty `byl/a` nejsou profesionální a generické mužské
  příčestí může nesprávně označit osobu či objekt.
- **Zdroje:** [MS-CS], [SURE]

## D-005 — Majetek, závazky a čisté jmění

- **Stav:** approved
- **Rozhodnutí:** V hlavním osobním finančním rozhraní se `asset`,
  `liability` a `net worth` překládají jako „majetek“, „závazek“ a „čisté
  jmění“. V odborném investičním nebo výkazovém kontextu může `asset` znamenat
  „aktivum“. `Liability` se bez účetního důvodu nepřekládá jako „pasivum“.
- **Důvod:** Sure třídí osobní majetek a dluhy; uživatelské rozhraní nemá
  předstírat účetní rozvahu tam, kde ji funkce neposkytuje.
- **Zdroje:** [SURE], [CNB-ACCOUNTS], [CNB-BALANCE]
- **Dopad:** Každý výskyt `asset` je nutné před překladem přiřadit k osobnímu,
  investičnímu nebo účetnímu kontextu.
- **Ověřeno:** 28. 7. 2026 v přehledu účtů, bočním panelu a dialogu odstranění
  účtu.

## D-006 — Plurály `one/few/many/other`

- **Stav:** approved
- **Rozhodnutí:** Česká lokalizace bude odpovídat CLDR a podporovat větve
  `one`, `few`, `many` a `other`. Před aktivací češtiny se doplní vlastní
  české pravidlo pro Rails a testy desetinných hodnot.
- **Důvod:** Použitá západoslovanská pluralizace `rails-i18n` nemá větev
  `many`, a proto není pro úplné české pravidlo dostačující.
- **Zdroje:** [CLDR-CS], [RAILS-I18N], [SURE]
- **Ověření po implementaci:** minimálně hodnoty `0`, `1`, `2`, `4`, `5`,
  `11`, `21`, `1.2` a celočíselná hodnota předaná desetinným datovým typem;
  samostatně Rails a Flutter. Je nutné zdokumentovat, zda běhové rozhraní
  zachovává informaci o viditelných desetinných místech.

## D-007 — Nezaúčtované a zaúčtované transakce

- **Stav:** approved
- **Rozhodnutí:** `pending transaction` je „nezaúčtovaná transakce“ a
  `posted transaction` je „zaúčtovaná transakce“. Krátký stav může být
  „Nezaúčtováno“.
- **Důvod:** Sure rozlišuje předběžnou transakci poskytovatele od její pozdější
  zaúčtované verze. Obecné „čekající“ tento bankovní význam nevystihuje.
- **Zdroje:** [SURE], [CNB-PAYMENTS]

## D-008 — Pozice a investiční nástroj

- **Stav:** approved
- **Rozhodnutí:** Model `Holding` a přehled `Holdings` se překládají jako
  „pozice“. Model `Security` je v obecném rozhraní „investiční nástroj“; tam,
  kde jde právně a významově o cenný papír, lze použít „cenný papír“.
- **Důvod:** „Držba“ je nepřirozený kalk. Model Sure může představovat širší
  množinu obchodovaných nástrojů než pouze cenné papíry.
- **Zdroje:** [SURE], [CNB-INVEST]
- **Dopad:** Bezpečnost aplikace se překládá „zabezpečení“ a nesmí se zaměnit
  s modelem `Security`.
- **Ověřeno:** 28. 7. 2026 v přehledu pozic, detailu pozice, výběru
  investičního nástroje a historii obchodů.

## D-009 — Více významů `reconciliation`

- **Stav:** approved
- **Rozhodnutí:** Kontrola výpisu proti evidenci je „odsouhlasení výpisu“.
  Automatická korekce účetního zůstatku je „dorovnání zůstatku“. Nahrazení
  předběžné transakce její zaúčtovanou verzí je „spárování nezaúčtované
  transakce“. Tyto procesy se nesmějí sloučit pod jeden obecný překlad.
- **Důvod:** Zdrojový kód Sure používá výraz pro několik odlišných operací.
- **Zdroje:** [SURE]
- **Dopad:** Jednotlivé klíče musí být při překladu dohledány v
  `ReconciliationManager`, ve funkcích výpisů a v importu transakcí
  poskytovatelů. Interní odsouhlasení pořizovací ceny investice může vyžadovat
  další kontextový ekvivalent, objeví-li se v uživatelském textu.

## D-010 — Částky, procenta a pevné mezery

- **Stav:** approved
- **Rozhodnutí:** České zobrazení používá desetinnou čárku a nedělitelnou
  mezeru mezi číslem a měnou, jednotkou nebo procentem. Formátování částek se
  ponechá lokalizačnímu formátovači, nikoli ručně skládaným překladům.
- **Důvod:** Česká typografie a prevence zalomení čísla od jednotky.
- **Zdroje:** [UJC], [MS-CS], [CLDR-CS]

## D-011 — Značky a technické identifikátory

- **Stav:** approved
- **Rozhodnutí:** `Sure`, názvy poskytovatelů, tickerové symboly, kódy měn,
  API, CSV, PDF, OAuth, SSO, IBAN, URL, cesty a identifikátory se
  nepřekládají. Okolní vysvětlení se překládá plně.
- **Důvod:** Překlad by poškodil funkčnost nebo identitu produktu.
- **Zdroje:** [SURE], [MS-CS]

## D-012 — Zrcadlení anglické struktury souborů

- **Stav:** approved
- **Rozhodnutí:** Česká Rails lokalizace zrcadlí anglické soubory po logických
  celcích a neslučuje se do jednoho velkého YAML. Výjimka vyžaduje technický
  důvod.
- **Důvod:** Usnadní porovnání klíčů, revize upstream změn i malé tematické
  commity.
- **Zdroje:** [SURE]

## D-013 — Fallback není důkaz úplnosti

- **Stav:** approved
- **Rozhodnutí:** Přestože Rails používá fallback, QA češtiny musí chybějící
  klíč považovat za chybu. Produkční zobrazení angličtiny nesmí maskovat
  neúplnost.
- **Důvod:** Cílem je technicky úplná lokalizace bez skrytých anglických
  řetězců.
- **Zdroje:** [SURE]

## D-014 — Locale e-mailů a úloh na pozadí

- **Stav:** approved
- **Rozhodnutí:** Nestačí přeložit katalogy. Každý e-mail a uživatelsky
  viditelný text vytvořený úlohou na pozadí musí běžet v locale příslušné
  rodiny nebo uživatele a musí mít automatický test.
- **Důvod:** Proces běžící mimo požadavek nemůže bezpečně zdědit locale
  webového požadavku.
- **Zdroje:** [SURE]

## D-015 — Mobilní a desktopová aplikace jsou součástí úplnosti

- **Stav:** approved
- **Rozhodnutí:** Flutter ARB se přeloží a zaregistruje pro `cs`. Desktopový
  klient potřebuje nejprve lokalizační mechanismus pro TypeScript i nativní
  nabídky v Rustu; jeho pevně zapsané anglické texty se nesmějí ignorovat.
- **Důvod:** Obě části mají vlastní textové zdroje mimo Rails YAML.
- **Zdroje:** [SURE]

## D-016 — Pevně zapsané uživatelské texty

- **Stav:** approved
- **Rozhodnutí:** Uživatelské texty nalezené přímo v modelech, úlohách,
  mailerech, TypeScriptu, Rustu nebo Dartu se zařadí do inventáře a podle
  architektury přesunou do lokalizačních zdrojů.
- **Důvod:** Překlad pouze existujících YAML souborů by nebyl úplný.
- **Zdroje:** [SURE]

## D-017 — Existující `defaults/cs.yml` není schválený překlad

- **Stav:** approved
- **Rozhodnutí:** Současný český soubor frameworkových výchozích textů se
  kompletně zreviduje, terminologicky sjednotí a rozšíří o správnou
  pluralizaci. Nebude se automaticky přebírat.
- **Důvod:** Soubor pokrývá pouze frameworkové výchozí texty, obsahuje
  nepřirozené formulace a používá jen větve `one/few/other`.
- **Zdroje:** [SURE], [CLDR-CS]

## D-018 — Angličtina je jediný strukturální zdroj

- **Stav:** approved
- **Rozhodnutí:** Úplnost a struktura se vždy porovnávají s aktuální
  angličtinou. Polština ani jiný jazyk není šablonou pro český soubor.
- **Důvod:** Kontrolovaná polská lokalizace proti angličtině postrádá více než
  dva tisíce významových klíčů a obsahuje vlastní odchylky.
- **Zdroje:** [SURE], [SURE-PL]

## D-019 — Zákaz nezkontrolovaného hromadného překladu

- **Stav:** approved
- **Rozhodnutí:** Překlady vznikají po funkčních celcích a každý řetězec
  projde kontextovou a jazykovou kontrolou. Automaticky vytvořený návrh nelze
  považovat za schválený výstup.
- **Důvod:** Gramaticky možný řetězec může mít v aplikaci chybný finanční nebo
  ovládací význam.
- **Zdroje:** [SURE], [MOZ-CS], [MS-CS]

## D-020 — Kreditní `APR` není česká RPSN

- **Stav:** approved
- **Rozhodnutí:** Pole `APR` u kreditní karty se překládá jako „roční úroková
  sazba (APR)“. Zkratka se zachová kvůli vazbě na zahraniční dokumentaci a
  údaj se neoznačí jako RPSN.
- **Důvod:** U kreditních karet představuje `APR` anualizovanou úrokovou
  sazbu. Česká RPSN naproti tomu vyjadřuje celkové náklady spotřebitelského
  úvěru a zahrnuje také další náklady. Automatické ztotožnění by změnilo
  význam údaje.
- **Zdroje:** [SURE], [CFPB-APR], [CNB-RPSN]
- **Ověřeno:** 28. 7. 2026 ve formuláři a přehledu kreditní karty.

## D-021 — Množství smíšených investičních nástrojů

- **Stav:** approved
- **Rozhodnutí:** V obecném přehledu pozic a obchodů se `share` a množství
  překládají jako „jednotka“. Výraz „akcie“ se použije jen tehdy, když je typ
  nástroje skutečně zaručený.
- **Důvod:** Model `Security` a stejné komponenty pozic obsluhují akcie, ETF,
  kryptoaktiva i další nástroje. Překlad „akcie“ by u části portfolia uváděl
  nesprávný druh aktiva.
- **Zdroje:** [SURE], [CNB-INVEST], [CNB-DIGITAL-ASSETS]
- **Ověřeno:** 28. 7. 2026 v přehledu pozic, editoru pořizovací hodnoty a
  historii obchodů.

## D-022 — Převod a platba na závazkový účet

- **Stav:** approved
- **Rozhodnutí:** Přesun mezi běžnými majetkovými účty je „převod“. Pokud
  cílový účet představuje závazek, například kreditní kartu nebo úvěr,
  uživatelský název je „platba na účet %{to_account}“.
- **Důvod:** Model `Transfer` tyto případy rozlišuje metodou `payment?`.
  Jednotný překlad „převod“ by skrýval účel pohybu a překlad „úhrada“ by byl
  v krátkém systémovém názvu zbytečně formální.
- **Zdroje:** [SURE], [CNB-PAYMENTS]
- **Ověřeno:** 28. 7. 2026 v modelu převodu, vytváření převodu a detailu
  transakce.

## D-023 — `Recurring transaction` je „opakující se transakce“

- **Stav:** approved
- **Rozhodnutí:** Funkce pro automaticky rozpoznanou nebo ručně vytvořenou
  pokračující řadu používá název „opakující se transakce“. Nepoužívá se
  „rekurentní transakce“, „opakovaná transakce“ ani obecně „pravidelná
  platba“.
- **Důvod:** Model připouští rozpětí částky a odhadovaný den, takže nemusí jít
  o přesně pravidelnou platbu. „Opakovaná“ navíc spíše popisuje již dokončený
  jednotlivý výskyt, zatímco rozhraní spravuje pokračující řadu.
- **Zdroje:** [SURE], [CNB-RECURRING], [MS-CS]
- **Ověřeno:** 29. 7. 2026 v přehledu, projekci, ručním označení transakce a
  opakujících se převodech.

## D-024 — Překlad výchozích názvů kategorií

- **Stav:** approved
- **Rozhodnutí:** Vestavěné názvy kategorií se překládají při zobrazení přes
  existující mapování `Category.localized_default_name_for`. Jejich uložené
  anglické identifikátory ani uživatelsky vytvořené názvy se automaticky
  nepřepisují.
- **Důvod:** Přepsání uložených názvů by mohlo narušit rozpoznání výchozích
  kategorií, importní mapování a přepínání jazyka. Vlastní názvy jsou
  uživatelská data, nikoli lokalizační řetězce.
- **Zdroje:** [SURE]
- **Ověřeno:** 29. 7. 2026 v modelu kategorie, výběru kategorie a slučování
  kategorií.

## D-025 — Překlad pravidel nesmí změnit interní hodnoty

- **Stav:** approved
- **Rozhodnutí:** Názvy filtrů, operátorů, akcí, druhů transakcí a
  investičních pohybů se lokalizují pouze při zobrazení. Hodnoty ukládané do
  pravidel, například `like`, `is_null`, `income` nebo
  `set_transaction_category`, zůstávají beze změny.
- **Důvod:** Uložené hodnoty jsou součástí vyhodnocování pravidel a změna
  podle jazyka uživatele by poškodila existující pravidla i přepínání locale.
- **Zdroje:** [SURE], [MS-CS]
- **Ověřeno:** 29. 7. 2026 v registrech podmínek a akcí, sestavovači pravidel
  a zobrazení uloženého pravidla.

## D-026 — Vlastní obchodník a obchodník od poskytovatele

- **Stav:** approved
- **Rozhodnutí:** `FamilyMerchant` se podle potřeby označuje jako „vlastní
  obchodník“, zatímco `ProviderMerchant` je „obchodník od poskytovatele“.
  Vlastní záznam lze odstranit; u záznamu synchronizovaného od poskytovatele
  se v uživatelském rozhraní používá „odebrat“, protože se pouze zruší jeho
  přiřazení k transakcím.
- **Důvod:** Obě třídy mají odlišný životní cyklus. Stejný popisek „odstranit“
  by uživateli nesprávně naznačoval, že se smaže i záznam poskytovatele.
- **Zdroje:** [SURE]
- **Ověřeno:** 29. 7. 2026 v přehledu obchodníků, potvrzovacích dialozích a
  slučování obchodníků.

## D-027 — `Family` je v uživatelském rozhraní „domácnost“

- **Stav:** approved
- **Rozhodnutí:** Datový model a interní identifikátor `Family` se nemění.
  V uživatelském rozhraní označuje společný finanční prostor výraz
  „domácnost“. „Rodina“ se použije jen v textu, který skutečně mluví o
  příbuzenském vztahu.
- **Důvod:** Do jednoho prostoru mohou patřit partneři, jednotlivci i jiné
  skupiny. „Domácnost“ přesněji popisuje společně spravované finance a
  nevnucuje uživatelům rodinný vztah.
- **Zdroje:** [SURE], [MS-CS]
- **Ověřeno:** 2. 8. 2026 v onboardingu, správě uživatelů, pozvánkách a
  administraci.

## D-028 — Stabilní hodnoty protokolů a poskytovatelů se nepřekládají

- **Stav:** approved
- **Rozhodnutí:** Hodnoty tvořící součást API, importního formátu nebo
  smlouvy s poskytovatelem zůstávají stabilní. Překládá se jejich uživatelský
  popisek a doprovodná zpráva, nikoli například ticker, MIC, typ aktivity,
  identifikátor pravidla nebo strojový chybový kód.
- **Důvod:** Překlad uložené či přenášené hodnoty by mohl poškodit import,
  synchronizaci, párování nebo zpětnou kompatibilitu.
- **Zdroje:** [SURE]
- **Ověřeno:** 2. 8. 2026 u IBKR, Trading 212, CoinStats, SimpleFIN,
  Sophtron, pravidel a importů.

## D-029 — Mobilní parsování částek respektuje locale a měnu

- **Stav:** approved
- **Rozhodnutí:** Mobilní klient nesmí odstraňovat desetinnou čárku ani
  předpokládat dvě desetinná místa. Přednost má přesná hodnota v nejmenších
  jednotkách měny; textová částka se parsuje podle aktivního locale.
- **Důvod:** Mechanické odstranění oddělovačů měnilo například českou částku
  `1 234,56` na řádově jinou hodnotu a dvě desetinná místa nejsou správná pro
  všechny měny.
- **Zdroje:** [SURE], [CLDR-CS]
- **Ověřeno:** 2. 8. 2026 ve společném parseru, modelu účtu, kalendáři,
  přehledu a seznamu transakcí.

## D-030 — Rails plurál odpovídá viditelně formátovanému množství

- **Stav:** approved
- **Rozhodnutí:** Produkční `format_quantity` odstraňuje nevýznamné koncové
  nuly, proto se integrální hodnoty `1.0`, `2.0` a `5.0` zobrazují jako `1`,
  `2` a `5` a používají celočíselné kategorie `one`, `few` a `other`.
  Hodnoty s nenulovou desetinnou částí používají `many`. Pokud nový call-site
  musí zobrazit koncovou nulu, předá pluralizaci i počet viditelných
  desetinných míst; samotný `Numeric` nestačí.
- **Důvod:** CLDR rozlišuje matematickou hodnotu a operand `v`. Ruby
  `Numeric` původní zápis spolehlivě nezachová, zatímco současné UI jej ani
  nezobrazuje. Text a plurální kategorie proto vycházejí ze stejného
  viditelného údaje bez nepravdivé deklarace obecné shody s CLDR.
- **Zdroje:** [SURE], [CLDR-CS]
- **Ověřeno:** 9. 9. 2026 v českém pluralizačním pravidle, helperu
  `format_quantity` a zobrazení investičních jednotek.

## D-031 — Obecný `Depository account` je „peněžní účet“

- **Stav:** approved
- **Rozhodnutí:** Společný typ Sure `Depository`, který zahrnuje běžné,
  spořicí, HSA, termínované a money-market účty, se označuje jako „peněžní
  účet“. Je-li znám konkrétní podtyp, použije se jeho přesný český název.
- **Důvod:** Samotný výraz „vkladový účet“ v českém uživatelském rozhraní
  přirozeně nepokrývá všechny podporované podtypy a mohl by uživatele mylně
  omezit při výběru účtu pro finanční cíl.
- **Zdroje:** [SURE], [CNB-ACCOUNTS]
- **Ověřeno:** 9. 9. 2026 v modelu `Depository` a asistentské funkci pro
  vytvoření cíle.

## D-032 — Technické chyby se nezobrazují přímo uživateli

- **Stav:** approved
- **Rozhodnutí:** Neočekávané výjimky a providerové chyby se ukládají přes
  `DebugLogEntry` s třídou výjimky a zkrácenou zprávou. Uživatelské rozhraní
  dostane stabilní lokalizovanou zprávu bez raw `error.message`; přímé
  zobrazení detailu je možné jen po výslovném bezpečném mapování.
- **Důvod:** Technická zpráva může obsahovat interní adresu, citlivý údaj,
  angličtinu nebo implementační detail. Pro podporu musí zůstat dohledatelná,
  ale nepatří do běžného lokalizovaného UI.
- **Zdroje:** [SURE]
- **Ověřeno:** 9. 9. 2026 v PDF importu, testu poskytovatele SSO a převodu
  transakce na investiční obchod.
