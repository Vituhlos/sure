# Executive summary

Audit byl proveden nezávisle nad revizí `66ffc034b4ba2ce0bd3c23627b7edf75c504e91e` (`.sure-version` = `0.7.4-alpha.1`) dne 9. 9. 2026. Referenční upstream překladové práce je `5f0f5ec89d66beb04415e05853ef6930b0d46592` z 1. 8. 2026. Při auditu byl současný `upstream/main` o 296 commitů dále, takže tento report hodnotí přesně stav tohoto forku, nikoli kompatibilitu s nejnovějším Sure.

Celkové hodnocení: česká lokalizace je obsahově velmi úplná a převážná většina textů je jazykově dobrá. V 141 párech Rails katalogů nebyl nalezen chybějící český soubor ani normalizovaný klíč, v ARB je 380/380 zpráv a desktop má úplnou typovanou větev `cs`. Nebyly nalezeny porušené HTML značky, odkazy ani skutečné neshody názvů interpolací. Stav však nelze označit za 100% hotový ani připravený k vydání: mobilní klient po zapojení několika lokalizovaných řetězců neprojde kompilací, audit dále potvrdil dvě chyby pluralizace, jedno významově zavádějící investiční označení, jeden nepřesný název druhu účtu a několik produkčních míst s natvrdo vloženou angličtinou. Hlavní HTML dokument je navíc i v češtině označen `lang="en"`.

Nejzávažnější výsledky:

- mobilní klient má tři lokalizační integrační chyby v Dart kódu (`l` mimo scope a lokalizovaný výraz uvnitř `const`), takže úplná sada `flutter test` obsahuje kompilační selhání;
- `recurring_transactions.expected_in` vykreslí pro 5 i 21 dní text „Očekáváno za 5 dne“ / „… za 21 dne“;
- Rails pravidlo neumí rozlišit viditelný desetinný zápis `1.0` od celého čísla `1`, a proto neplní CLDR pro desetinná čísla s nulovou desetinnou částí;
- „Book Value“ je v UI přeloženo jako „Účetní hodnota“, ačkoli zdrojový kód zobrazuje `avg_cost × qty`, tedy celkovou pořizovací hodnotu (cost basis), nikoli účetní hodnotu ve standardním účetním smyslu;
- hlavní web, tisk a OAuth deklarují angličtinu v atributu `lang`; OAuth souhlas, stav odstraňování účtu, přístupnost řazení dashboardu a několik potvrzení/titulků navíc obsahují přímo anglický text.

Za autoritativní byly použity skutečné call-site v Sure, aktuální materiály ČNB, Internetová jazyková příručka ÚJČ, [Unicode CLDR – česká plurální pravidla](https://unicode.org/cldr/charts/49/supplemental/language_plural_rules.html), [česká gramatická data CLDR](https://www.unicode.org/cldr/charts/49/grammar/cs.html), [Mozilla Czech Style Guide](https://mozilla-l10n.github.io/styleguides/cs/general.html) a Microsoft Czech Style Guide uvedený v `docs/localization/cs/SOURCES.md`. CLDR výslovně rozlišuje `1` a viditelný desetinný zápis a pro češtinu uvádí desetinné hodnoty v kategorii `many` (např. `10,0 dne`). ČNB zároveň potvrzuje, že RPSN zahrnuje vedle úroku i další náklady; stávající rozhodnutí nepřekládat kreditní `APR` automaticky jako RPSN je proto správné: [ČNB – Co je ukazatel RPSN?](https://www.cnb.cz/cs/casto-kladene-dotazy/Co-je-ukazatel-RPSN).

# Critical issues

## C-01 — Lokalizační integrace brání kompilaci mobilního klienta

- **Cesta / klíč:** `mobile/lib/screens/main_navigation_screen.dart:144,154` (`navTogglePrivacy`); `mobile/lib/screens/sso_onboarding_screen.dart:120-124` (`localizedClientError`); `mobile/lib/widgets/account_card.dart:159-170` (`accountCardTransactions`).
- **Anglický originál:** `Toggle privacy`; dynamická bezpečná klientská chyba, např. `Something went wrong. Please try again.`; `Transactions`.
- **Současný CS:** `Skryje nebo zobrazí částky`; mapované české klientské chyby; `Transakce`. Samotné překlady jsou použitelné, ale Dart se k nim ve třech call-site nedokáže korektně zkompilovat.
- **Doporučení:** Do `_buildTopBar` předat `AppLocalizations l` nebo jej získat z dostupného `BuildContext`; v `SsoOnboardingScreen.build` definovat `final l = AppLocalizations.of(context)` (případně předat výsledek přímo); u swipe akce účtu odstranit `const` z `Column`, která obsahuje runtime getter `l.accountCardTransactions`, a zachovat `const` jen u skutečně konstantních potomků. Poté spustit analyzátor, celý `flutter test` a release build.
- **Vysvětlení:** Flutter 3.32.4 hlásí u obou obrazovek `The getter 'l' isn't defined` a u karty účtu `Not a constant expression`. Nejde o hypotetické riziko ani o rozdíl prostředí: jsou to statické chyby přímo ve zdrojovém kódu lokalizačních call-site.
- **Kontext:** tooltip a accessibility label přepínače soukromí v hlavní navigaci, chyba během SSO onboardingu a popisek swipe akce na kartě účtu.
- **Závažnost:** **critical — release blocker**. Mobilní aplikaci nelze v tomto stavu spolehlivě sestavit; minimálně testovací kompilace příslušných obrazovek prokazatelně selhává.

# Major issues

## M-01 — Prohozené větve `many` a `other` u počtu dní

- **Cesta / klíč:** `config/locales/views/recurring_transactions/cs.yml:9`, `recurring_transactions.expected_in`; použití `app/views/recurring_transactions/_projected_transaction.html.erb:45`.
- **Anglický originál:** `one: "Expected in %{count} day"`, `other: "Expected in %{count} days"`.
- **Současný CS:** `one: "Očekáváno za %{count} den"`; `few: "… dny"`; `many: "… dní"`; `other: "… dne"`.
- **Doporučení:** `many: "Očekáváno za %{count} dne"`; `other: "Očekáváno za %{count} dní"`.
- **Vysvětlení:** Větve jsou prohozené. Přímý runtime test v Rails vrátil „Očekáváno za 5 dne“ a „Očekáváno za 21 dne“. `days_left` je celé číslo, takže chyba zasahuje běžný produkční stav.
- **Kontext:** štítek u očekávané opakující se transakce.
- **Závažnost:** **major**.

## M-02 — Rails pravidlo nezachovává viditelná desetinná místa podle CLDR

- **Cesta / klíč:** `config/initializers/czech_pluralization.rb:5-13`, výběr české plurální kategorie.
- **Anglický originál / požadavek:** CLDR pracuje s operandy viditelných desetinných míst; české `many` zahrnuje desetinné zápisy včetně `1.0`, `2.0` a `5.0`.
- **Současný CS / chování:** pravidlo testuje jen `(count % 1).zero?`; `1.0` → `one`, `2.0` → `few`, `5.0` → `other`. Stejně dopadly `BigDecimal("1.0")`, `BigDecimal("2.0")` a `BigDecimal("5.0")`.
- **Doporučení:** Nepředávat do pluralizace samotný `Numeric`, pokud UI skutečně zobrazuje desetinnou přesnost. Přenést zároveň informaci o viditelných desetinných místech, případně pro množství vytvořit formátovací helper, který společně vybere tvar i český zobrazený počet. Testovat integer, `Float`, `BigDecimal` a hodnotu načtenou z databázového `decimal`.
- **Vysvětlení:** Matematická integrálnost není totéž jako CLDR operand `v` (počet viditelných desetinných míst). Ruby `Float` a běžné numerické předání tuto informaci nezachová; současná lambda ji ani nezkoumá.
- **Kontext:** především zlomkové investiční jednotky. `format_quantity` v `app/helpers/application_helper.rb:240-256` odstraňuje nevýznamné nuly, takže v aktuálním seznamu pozic se `1.0` zobrazí jako `1` a konkrétní výstup je náhodou konzistentní. Obecná deklarace „CLDR compliant“ však pravdivá není.
- **Závažnost:** **major** (běhová lokalizační infrastruktura; současný dopad je omezen formátováním).

## M-03 — „Book Value“ označuje ve skutečnosti pořizovací hodnotu

- **Cesta / klíč:** `config/locales/views/holdings/cs.yml:109`, `holdings.show.book_value_label`; výpočet `app/views/holdings/show.html.erb:199-203`; glosář řádek 52.
- **Anglický originál:** `Book Value`.
- **Současný CS:** `Účetní hodnota`.
- **Doporučení:** `Pořizovací hodnota` nebo, pro odlišení od jednotkové ceny, `Celková pořizovací hodnota`.
- **Vysvětlení:** Hodnota je přímo `@holding.avg_cost * @holding.qty`. Jde o celkový cost basis pozice. Aplikace zde nečte účetní ocenění, carrying amount ani účetní knihy. Český text proto dodává hodnotě odborný význam, který výpočet nemá.
- **Kontext:** detail investiční pozice vedle „Průměrné pořizovací ceny“ a „Tržní hodnoty“.
- **Závažnost:** **major** (zavádějící finanční označení; číselná hodnota sama je vypočtena správně).

## M-04 — `Depository account` je v asistentské funkci zúženo na „vkladový účet“

- **Cesta / klíč:** `config/locales/models/assistant/cs.yml:42-43`, `assistant.functions.create_goal.no_linked_accounts` a `unknown_accounts`; význam `app/models/assistant/function/create_goal.rb:19-24,85`.
- **Anglický originál:** `Please specify at least one Depository account…`; `…the user's Depository accounts.`
- **Současný CS:** `Vyberte alespoň jeden vkladový účet…`; `…žádnému vkladovému účtu uživatele.`
- **Doporučení:** `Vyberte alespoň jeden peněžní účet…`; druhá věta `Některé názvy neodpovídají žádnému peněžnímu účtu uživatele.` Alternativně explicitně `běžný nebo spořicí účet`, pokud má text odpovídat zbytku UI.
- **Vysvětlení:** Zdrojový typ zahrnuje checking, savings, HSA, CD a money-market. „Vkladový účet“ v běžném českém UI nepokrývá přirozeně všechny tyto účty a neodpovídá ani existujícímu textu `Běžný nebo spořicí účet` v nastavení poskytovatelů.
- **Kontext:** chybová odpověď asistenta při vytváření cíle; uživatel podle ní vybírá účty započítané do cíle.
- **Závažnost:** **major** (významově zužující terminologie).

# Minor issues

## N-01 — Strojově působící pasivum „byl úspěšně…“ a nejednotná interpunkce

- **Cesta / klíč:** reprezentativně `config/locales/views/mercury_items/cs.yml:62`, `mercury_items.create.success`; stejný vzorec se v českých katalozích vyskytuje na 64 řádcích.
- **Anglický originál:** `Mercury connection created successfully`.
- **Současný CS:** `Připojení Mercury bylo úspěšně vytvořeno`.
- **Doporučení:** `Připojení ke službě Mercury bylo vytvořeno.` nebo stručně `Služba Mercury byla připojena.`
- **Vysvětlení:** Text je gramaticky možný, ale příslovce je po jednoznačně úspěšné akci redundantní a konstrukce působí jako kalk. Některé obdobné zprávy mají tečku, jiné ne. Ne všech 64 výskytů je nutné mechanicky přepsat; doporučena je kontextová jazyková revize.
- **Kontext:** potvrzovací flash zprávy poskytovatelů.
- **Závažnost:** **minor / UX styl**.

## N-02 — Nejasné „Účet byl odstraněn“ po smazání uživatele

- **Cesta / klíč:** `config/locales/views/users/cs.yml:5`, `users.destroy.success`; použití `app/controllers/users_controller.rb:65-70`.
- **Anglický originál:** `Your account has been deleted.`
- **Současný CS:** `Účet byl odstraněn.`
- **Doporučení:** `Uživatelský účet byl odstraněn.`
- **Vysvětlení:** Sure používá „účet“ převážně pro finanční účet. Po deaktivaci uživatele je vhodné explicitně odlišit uživatelský účet, jak požaduje i glosář.
- **Kontext:** potvrzení po odstranění profilu a relace uživatele.
- **Závažnost:** **minor**.

## N-03 — „Volná hotovost“ je správně pochopitelná, ale v investičním UI diskutabilní

- **Cesta / klíč:** `config/locales/views/holdings/cs.yml:5`, `holdings.cash.brokerage_cash`; `config/locales/views/valuations/cs.yml:11`; glosář řádek 45.
- **Anglický originál:** `Brokerage cash`.
- **Současný CS:** `Volná hotovost`.
- **Doporučení:** zvážit `Volné peněžní prostředky`; případně ponechat „Volná hotovost“, pokud uživatelský výzkum potvrdí srozumitelnost.
- **Vysvětlení:** Nejde o fyzickou hotovost, nýbrž neinvestovaný peněžní zůstatek u brokera. Současná varianta není odborně chybná, ale může v češtině evokovat bankovky a mince.
- **Kontext:** investiční účet a jeho ocenění.
- **Závažnost:** **minor / UX doporučení**, nikoli automatická chyba.

## N-04 — Test českého zlomkového množství očekává anglický desetinný oddělovač

- **Cesta / klíč:** `test/lib/czech_pluralization_test.rb:40-44`.
- **Anglický originál:** není lokalizační klíč; test vkládá řetězec `"1.5"`.
- **Současný CS:** očekává `1.5 jednotky`.
- **Doporučení:** testovat produkční cestu přes `format_quantity` a očekávat `1,5 jednotky`; samostatně testovat jen volbu kategorie s neutrálním placeholderem.
- **Vysvětlení:** Produkční helper používá lokalizované formátování, ale test ho obchází. Zelený test proto současně legitimizuje typograficky nečeský výstup.
- **Kontext:** regresní test pluralizace investičních jednotek.
- **Závažnost:** **minor (kvalita testu)**.

## N-05 — Některé `many` větve jsou gramaticky stejné jako `other`

- **Cesta / klíč:** např. `config/locales/views/transactions/cs.yml:37-38`, `transactions.bulk_deletions.create.success`; dále `categories.perform_merge.success`, `recurring_transactions.identified`, `recurring_transactions.cleaned_up`, `transactions.categorizes.show.remaining`, `transaction_count` a `categorized`.
- **Anglický originál:** množné počty typu `Deleted %{count} transactions`.
- **Současný CS:** u příkladu `many` i `other`: `Odstraněno %{count} transakcí`.
- **Doporučení:** pokud má katalog deklarovat obecnou podporu desetinných hodnot, `many` má mít např. `Odstraněno %{count} transakce`; pokud je počet z definice vždy celočíselný, zdokumentovat, že je `many` pouze strukturální a za běhu nedosažitelná.
- **Vysvětlení:** Automatická kontrola našla 16 skupin s identickým `many`/`other`; devět je neutrálních nebo technických, sedm by pro skutečné desetinné číslo mělo nesprávný pád. Aktuální call-site předávají počty položek jako celá čísla, proto nejde o současnou produkční chybu.
- **Kontext:** hromadné mazání, kategorizace, slučování a počty opakování.
- **Závažnost:** **minor / latentní riziko**.

## N-06 — Dokumentace QA již neodpovídá auditovanému stromu

- **Cesta / klíč:** `docs/localization/cs/QA_REPORT.md:14-18,35`; `docs/localization/cs/README.md:19-20`.
- **Anglický originál / tvrzení:** není překladový řetězec.
- **Současný CS:** QA uvádí 140 párů, 7 678 hodnot, 210 plurálních skupin a 24 344 asercí; README tvrdí, že nebyl vytvořen commit ani push.
- **Doporučení:** po opravách přegenerovat metriky (nyní 141 párů, 7 769 normalizovaných hodnot, 211 skupin a v aktuálním běhu 24 347 asercí) a odstranit historické tvrzení o neexistujícím commitu/pushi.
- **Vysvětlení:** Dokumentace je důležitá pro auditní stopu, ale její čísla už nejsou důkazem současného stavu.
- **Kontext:** interní dokumentace lokalizace.
- **Závažnost:** **minor / dokumentace**.

# Terminology review

| EN | současný CS | doporučený CS | kontext | závažnost | důvod |
|---|---|---|---|---|---|
| account | účet | účet | obecný finanční účet | OK | Přirozený obecný termín. |
| financial account | finanční účet / účet | beze změny | pouze při potřebě odlišit od profilu | OK | Kontext obvykle dovoluje kratší „účet“. |
| user account | místy uživatelský účet, místy jen účet | uživatelský účet tam, kde hrozí záměna | profil, přihlášení, OAuth, SSO | minor | Nutné odlišit od finančního účtu; viz N-02. |
| bank account | bankovní účet | bankovní účet jen pro banku | napojené bankovní účty | minor v glosáři | Ne každý účet od poskytovatele je bankovní. |
| asset | majetek / aktivum | beze změny podle kontextu | osobní finance / odborné investice | OK | Správné funkční rozlišení. |
| liability | závazek | závazek | dluhová strana přehledu | OK | „Pasivum“ by bylo příliš účetní. |
| debt | dluh | dluh | osobní dlužná částka | OK | Přirozené pro spotřebitelské UI. |
| loan | úvěr | úvěr; půjčka jen podle smluvního produktu | druh účtu | podle kontextu | Absolutní zákaz „půjčka“ není udržitelný. |
| mortgage | hypotéka | hypotéka / hypoteční úvěr | krátký název / souvislý odborný text | OK | Rozlišení je vhodné. |
| principal | jistina | jistina | úvěr | OK | Odborně správné. |
| interest | úrok | úrok | částka úroku | OK | Nezaměňovat se sazbou. |
| interest rate | úroková sazba | úroková sazba | procentní veličina | OK | Odborně i uživatelsky správné. |
| APR | roční úroková sazba (APR) | beze změny | kreditní karta | OK | Není totožné s českou RPSN. |
| RPSN | RPSN | RPSN | celkové náklady spotřebitelského úvěru | OK | ČNB potvrzuje širší obsah než samotný úrok. |
| balance | zůstatek | zůstatek | finanční účet | OK | Správně odlišeno od bilance. |
| available balance | disponibilní zůstatek | disponibilní zůstatek | bankovní dostupná částka | OK | Standardní bankovní výraz. |
| current balance | aktuální zůstatek / místy aktuální hodnota | podle objektu | účet vs. investice/majetek | OK | U nepeněžního majetku je „hodnota“ vhodnější. |
| opening balance | počáteční zůstatek | počáteční zůstatek | výpis / založení účtu | OK | Přirozené a přesné. |
| net worth | čisté jmění | čisté jmění | souhrn majetku po závazcích | OK | Zavedený termín osobních financí. |
| transaction | transakce | transakce | model peněžního pohybu | OK | Konzistentní. |
| pending transaction | nezaúčtovaná transakce | nezaúčtovaná transakce | provider pending → posted | OK | Odpovídá skutečnému slučování verzí. |
| posted transaction | zaúčtovaná transakce | zaúčtovaná transakce | konečná bankovní verze | OK | Správný bankovní význam. |
| transfer | převod | převod | mezi účty | OK | Přirozené. |
| payment | platba | platba; „úhrada“ povolit podle věty | obecně vs. `Transfer.payment?` | podle kontextu | Definice v glosáři je příliš svázaná s jedním modelem. |
| recurring transaction | opakující se transakce | beze změny | rozpoznaná řada transakcí | OK | Přesnější než „pravidelná“, pokud interval/částka kolísá. |
| reconciliation | odsouhlasení / dorovnání / spárování | beze změny podle funkce | výpis / zůstatek / pending | OK | Správně rozlišeny tři různé mechanismy. |
| merchant | obchodník | obchodník | karetní či jiná platba | OK | Nezaměňuje se s příjemcem. |
| payee | příjemce | příjemce | protistrana platby | OK | Správně. |
| provider merchant | obchodník od poskytovatele | beze změny | externě dodaný merchant | OK | Poněkud delší, ale srozumitelné. |
| security | investiční nástroj / cenný papír | beze změny podle typu | obecný model zahrnující i krypto | OK | Širší termín brání chybné klasifikaci kryptoaktiva. |
| holding / position | pozice | pozice | investiční portfolio | OK | Přirozený odborný termín. |
| share / unit | jednotka; akcie jen pro prokazatelnou akcii | beze změny | zlomkové množství různých nástrojů | OK | Obecné `Security` nelze bezpečně nazývat akcií. |
| portfolio | portfolio | portfolio | soubor pozic | OK | Zavedený český termín. |
| return (amount) | výnos | výnos | absolutní investiční výsledek | OK / UX | Odborně přijatelné; pro negativní hodnotu lze zvážit neutrální „výsledek“. |
| return % | výnosnost | výnosnost | relativní výsledek | OK | Správně odlišeno od částky. |
| gain/loss | zisk/ztráta | zisk/ztráta | realizovaný či nerealizovaný výsledek | OK | Významově přesnější tam, kde UI ukazuje znaménko. |
| cost basis | pořizovací hodnota | pořizovací hodnota | celkový základ nákladů pozice | OK | V daném spotřebitelském UI srozumitelné. |
| average cost | průměrná pořizovací cena | beze změny | cena na jednotku | OK | Odpovídá `avg_cost`. |
| book value | účetní hodnota | celková pořizovací hodnota | `avg_cost × qty` | major | Implementace nemá účetní carrying amount; viz M-03. |
| market value | tržní hodnota | tržní hodnota | množství × aktuální cena / ocenění majetku | OK, zpřesnit definici | Termín je správný, glosář je příliš nemovitostně formulován. |
| cash | hotovost | hotovost; peněžní prostředky podle kontextu | fyzická hotovost vs. účet | OK podle kontextu | Nelze používat mechanicky pro každý `Depository`. |
| brokerage cash | volná hotovost | zvážit volné peněžní prostředky | neinvestovaný zůstatek u brokera | minor / UX | Viz N-03. |
| budget | rozpočet | rozpočet | plán výdajů/příjmů | OK | Přirozené. |
| goal | cíl | cíl | spořicí finanční cíl | OK | Kontext je zřejmý. |
| contribution | vklad / příspěvek | beze změny podle kontextu | investice / příspěvek na provoz Sure | OK | Stávající rozlišení je správné. |
| rollover | není v uživatelském UI | nerozhodovat před vznikem call-site | jen interní Kraken typ v `SKIP_TYPES` | N/A | Stabilní provider hodnota se nepřekládá. |

# Pluralization review

## Rails

Skutečný výběr provádí lambda v `config/initializers/czech_pluralization.rb`. Celá čísla jsou mapována `1 → one`, `2–4 → few`, ostatní → `other`; necelá matematická čísla → `many`. To je správné pro čísla s nenulovou desetinnou částí, nikoli pro viditelný zápis s nulovou desetinnou částí.

| vstup | typ v testu | očekávání CLDR | Rails výsledek | stav |
|---:|---|---|---|---|
| 0 | Integer | other | other | OK |
| 1 | Integer | one | one | OK |
| 2 | Integer | few | few | OK |
| 3 | Integer | few | few | OK |
| 4 | Integer | few | few | OK |
| 5 | Integer | other | other | OK |
| 10 | Integer | other | other | OK |
| 11 | Integer | other | other | OK |
| 12 | Integer | other | other | OK |
| 14 | Integer | other | other | OK |
| 20 | Integer | other | other | OK |
| 21 | Integer | other | other | OK |
| 22 | Integer | other | other | OK |
| 24 | Integer | other | other | OK |
| 25 | Integer | other | other | OK |
| 100 | Integer | other | other | OK |
| 101 | Integer | other | other | OK |
| 1.0 | Float, viditelně zamýšleno `.0` | many | one | chyba / informace ztracena |
| 1.1 | Float | many | many | OK |
| 1.2 | Float | many | many | OK |
| 1.5 | Float | many | many | OK |
| 2.0 | Float, viditelně zamýšleno `.0` | many | few | chyba / informace ztracena |
| 2.1 | Float | many | many | OK |
| 4.5 | Float | many | many | OK |
| 5.0 | Float, viditelně zamýšleno `.0` | many | other | chyba / informace ztracena |
| 1.0 | `BigDecimal("1.0")` | many, pokud má UI zachovat `.0` | one | chyba / nelze spolehlivě rozlišit |
| 2.0 | `BigDecimal("2.0")` | many, pokud má UI zachovat `.0` | few | chyba / nelze spolehlivě rozlišit |
| 5.0 | `BigDecimal("5.0")` | many, pokud má UI zachovat `.0` | other | chyba / nelze spolehlivě rozlišit |

V katalozích bylo nalezeno 211 úplných skupin `one/few/many/other`; žádné skupině větev nechybí. Samotná přítomnost větví ale neodhalila M-01. Přímé překlady `recurring_transactions.expected_in` byly: 1 → „1 den“, 2/4 → „2/4 dny“, 5 → „5 dne“, 21 → „21 dne“, 1,5 → „1.5 dní“.

Pád neurčuje jen kategorie. Například po předložce `před` je pro 5 správně „před 5 dny“, zatímco nominativní počet je „5 dní“. Většina katalogu toto rozlišení provádí správně (`goals.last_pledge_confirmed`, relativní čas, provider health texty). Chyba M-01 je konkrétní prohození tvarů, nikoli důvod globálně měnit všechny výskyty `dne/dny/dní`.

## Flutter / ICU

V `mobile/lib/l10n/app_cs.arb` jsou tři ICU plural messages: `transactionsListDeletedMulti`, `connectivityPendingSync` a `chatListDeleteMultiContent`. Všechny mají `one/few/many/other` a české tvary jsou pro příslušné kategorie správné. Generované metody v `mobile/lib/l10n/app_localizations_cs.dart:241,536,672` však přijímají výhradně `int count`. Z toho plyne:

- celočíselná matice 0, 1, 2, 3, 4, 5, 10, 11, 12, 14, 20, 21, 22, 24, 25, 100, 101 je pro tyto call-site pokryta významově správně;
- hodnoty 1.0, 1.1, 1.2, 1.5, 2.0, 2.1, 4.5 a 5.0 nelze těmto metodám předat bez změny typu, takže jejich runtime test pro současné API není definován;
- to není aktuální produktová chyba: všechny tři zprávy počítají položky seznamu/fronty. Je však nepřesné tvrdit, že mobilní runtime byl otestován na desetinné hodnoty.

## Interpolace

Branch-aware porovnání názvů i počtu placeholderů nenašlo skutečnou neshodu EN/CS v Rails ani ARB. U české větve `one` je někdy `%{count}` záměrně nahrazeno číslicí `1`; to není chybějící runtime parametr. HTML značky, `href`/`src` a Markdown konstrukce se mezi páry neliší. Nebyla potvrzena věta, která by vyžadovala skloňovat dynamický název účtu, obchodníka či poskytovatele způsobem, který runtime neumí: překlady obvykle používají dvojtečku, přístavek nebo konstrukci „účet %{name}“.

# Glossary review

Audit zahrnul všech 82 datových řádků `docs/localization/cs/GLOSSARY.csv`. Podrobné změny jsou pod tabulkou; `OK` znamená, že termín, definice i zákaz variant odpovídají nalezenému produktovému kontextu.

| ř. | EN | CS | verdikt | stručné odůvodnění |
|---:|---|---|---|---|
| 1 | account | účet | OK | obecný finanční účet |
| 2 | account | uživatelský účet | OK | správné odlišení identity |
| 3 | account | bankovní účet | nedostatečně přesně definováno | „napojený přes poskytovatele“ může být broker/krypto, nikoli banka |
| 4 | default account | výchozí účet | OK | správný význam předvolby |
| 5 | activity | pohyby | OK | vhodné pro souhrnnou záložku |
| 6 | entry | záznam | OK | obecný modelový pojem |
| 7 | transaction | transakce | OK | standardní produktový termín |
| 8 | transfer | převod | OK | přesun mezi účty |
| 9 | payment | platba | nedostatečně přesně definováno | definice popisuje jen `Transfer.payment?`, ne obecné payment |
| 10 | inflow transaction | příchozí transakce | OK | směr převodu |
| 11 | outflow transaction | odchozí transakce | OK | směr převodu |
| 12 | source account | zdrojový účet | OK | nezaměňuje se s výchozím |
| 13 | destination account | cílový účet | OK | přirozené |
| 14 | balance | zůstatek | OK | bankovní/přehledový význam |
| 15 | valuation | ocenění | OK | historický záznam hodnoty |
| 16 | market value | tržní hodnota | vyžaduje změnu definice | u pozic je to množství × kotovaná cena, ne pouze odhad prodejní ceny majetku |
| 17 | purchase price | pořizovací cena | závisí na kontextu | zákaz „kupní cena“ odporuje vlastní poznámce o smluvním kontextu |
| 18 | balance sheet | rozvaha | OK | odborně správné |
| 19 | available balance | disponibilní zůstatek | OK | standardní bankovní termín |
| 20 | pending | nezaúčtováno | OK | krátký stav |
| 21 | pending transaction | nezaúčtovaná transakce | OK | odpovídá provider flow |
| 22 | posted | zaúčtováno | OK | krátký stav |
| 23 | posted transaction | zaúčtovaná transakce | OK | bankovní kontext |
| 24 | merchant | obchodník | OK | správně odlišeno od příjemce |
| 25 | provider merchant | obchodník od poskytovatele | OK | srozumitelné |
| 26 | payee | příjemce | OK | správná protistrana |
| 27 | category | kategorie | OK | konzistentní |
| 28 | tag | štítek | OK | konzistentní |
| 29 | categorization | kategorizace | OK | správný proces/sloveso |
| 30 | attachment | příloha | OK | uživatelský soubor |
| 31 | split transaction | rozdělená transakce | OK | správný produktový význam |
| 32 | one-time transaction | jednorázová transakce | OK | není zaměněna s jedinou |
| 33 | duplicate transaction | duplicitní transakce | OK | správně odlišena akce duplikovat |
| 34 | budget | rozpočet | OK | přirozené |
| 35 | income | příjem | OK | neplést s investičním výnosem |
| 36 | expense | výdaj | OK | vhodnější než účetní náklad |
| 37 | asset | majetek | OK | vhodné pro osobní finance |
| 38 | asset | aktivum | OK | vhodné v odborném kontextu |
| 39 | liability | závazek | OK | vhodné pro dluhovou stranu |
| 40 | net worth | čisté jmění | OK | správný termín |
| 41 | investment | investice | OK | podle produktu lze zpřesnit |
| 42 | trade | obchod | OK | nákup/prodej nástroje |
| 43 | holding | pozice | OK | investiční terminologie |
| 44 | holdings | pozice | OK | investiční terminologie |
| 45 | brokerage cash | volná hotovost | správné, ale stylisticky diskutabilní | viz N-03 |
| 46 | security | investiční nástroj | OK | správně širší než cenný papír |
| 47 | security | cenný papír | OK | jen při potvrzeném typu |
| 48 | return | výnos | OK / UX | odborně přijatelné; u záporné hodnoty lze zvažovat neutrálnější popisek |
| 49 | return | výnosnost | OK | procentní veličina |
| 50 | cost basis | pořizovací hodnota | OK | vhodné pro spotřebitelské UI |
| 51 | average cost | průměrná pořizovací cena | OK | na jednotku |
| 52 | book value | účetní hodnota | vyžaduje změnu | konkrétní Sure výpočet je cost basis, viz M-03 |
| 53 | unrealized gain/loss | nerealizovaný zisk nebo ztráta | OK | přesný neutrální termín |
| 54 | principal | jistina | OK | úvěrový kontext |
| 55 | interest | úrok | OK | částka/cena úvěru |
| 56 | interest rate | úroková sazba | OK | procentní veličina |
| 57 | APR | roční úroková sazba (APR) | OK | správně není RPSN |
| 58 | tax treatment | daňový režim | OK | přirozené |
| 59 | loan | úvěr | závisí na kontextu | „půjčka“ nelze absolutně zakázat, když tak zní konkrétní produkt/smlouva |
| 60 | mortgage | hypotéka | OK | krátký UI název |
| 61 | mortgage loan | hypoteční úvěr | OK | správný odborný tvar |
| 62 | recurring transaction | opakující se transakce | OK | nemusí být dokonale pravidelná |
| 63 | reconciliation | odsouhlasení výpisu | OK | výpisový kontext |
| 64 | reconciliation | dorovnání zůstatku | OK | korekční záznam |
| 65 | reconciliation | spárování nezaúčtované transakce | OK | pending → posted |
| 66 | synchronization | synchronizace | OK | správný proces |
| 67 | sync | synchronizovat | OK | tlačítko/akce |
| 68 | synced | synchronizováno | OK | krátký stav |
| 69 | institution | finanční instituce | OK | banka/broker/organizace |
| 70 | provider | poskytovatel | OK | externí služba |
| 71 | data provider | poskytovatel dat | OK | správné zpřesnění |
| 72 | import | import | OK | softwarový proces |
| 73 | import | importovat | OK | akční infinitiv |
| 74 | rule | pravidlo | OK | automatizace |
| 75 | condition | podmínka | OK | test pravidla |
| 76 | action | akce | OK | operace pravidla |
| 77 | cash | hotovost | OK podle kontextu | poznámka správně omezuje použití |
| 78 | debt | dluh | OK | osobní finance |
| 79 | statement | výpis | OK | bankovní/účetní dokument |
| 80 | exchange rate | směnný kurz | OK | jednotlivý kurz |
| 81 | portfolio | portfolio | OK | zavedený český termín |
| 82 | ticker | ticker | OK | stabilní burzovní identifikátor |

Doporučené zásahy do glosáře:

1. U řádku 3 omezit `bankovní účet` skutečně na účet vedený bankou; samotné napojení přes provider nestačí.
2. U řádku 9 rozdělit obecné `payment` a speciální predikát modelu `Transfer.payment?`; „úhrada“ nezakazovat mimo kontext modelového štítku.
3. U řádku 16 doplnit investiční definici tržní hodnoty jako množství × aktuální tržní cena; odhad výslovně vyžadovat jen tam, kde zdroj skutečně odhad poskytuje.
4. U řádku 17 přesunout „kupní cenu“ z absolutně zakázaných variant do kontextových alternativ.
5. U řádku 45 rozhodnout UX testem mezi „volnou hotovostí“ a „volnými peněžními prostředky“.
6. U řádku 52 změnit Sure-specifické `book value` na „celkovou pořizovací hodnotu“, dokud implementace počítá `avg_cost × qty`.
7. U řádku 59 změnit absolutní zákaz „půjčka“ na kontextové pravidlo. ČNB sama ve vymezení spotřebitelského úvěru rozlišuje odloženou platbu, peněžitou zápůjčku, úvěr a obdobnou službu: [ČNB – Spotřebitelský úvěr](https://www.cnb.cz/cs/dohled-financni-trh/ochrana-spotrebitele/spotrebitelsky-uver/index.html).
8. Přidat samostatný termín `Depository account` s doporučením „peněžní účet“ nebo konkrétním druhem účtu; nepoužívat mechanicky „vkladový účet“.

# Hardcoded English

| ID | cesta / řádek | EN originál / současný stav v CS | doporučená varianta | kontext | závažnost / vysvětlení |
|---|---|---|---|---|---|
| H-01 | `app/views/accounts/_account.html.erb:17` | `(deletion in progress...)` / stejná angličtina | `(probíhá odstraňování…)`, přes nový i18n klíč | seznam účtů při background deletion | **major** — běžně viditelný produkční stav; výpustka má být znak `…` |
| H-02 | `app/views/pages/dashboard.html.erb:56` | `%{section} section. Press Enter or Space to grab for reordering, then use arrow keys to move.` / částečně český název + anglický návod | `%{section}. Stisknutím Enteru nebo mezerníku zahájíte přesouvání; polohu změníte šipkami.` | `aria-label` řaditelného widgetu | **major** — angličtina je dostupná právě uživateli čtečky obrazovky |
| H-03 | `app/views/layouts/shared/_htmldoc.html.erb:7` | `lang="en"` / i při `I18n.locale == :cs` | dynamický BCP 47 tag odvozený z aktivního locale | hlavní webový dokument | **major** — čtečka obrazovky a jazykové nástroje dostanou nesprávný jazyk |
| H-04 | `app/views/layouts/print.html.erb:2` | `lang="en"` | dynamický jazyk dokumentu | tiskové reporty | **major** — český report je označen jako anglický |
| H-05 | `app/views/layouts/doorkeeper/application.html.erb:4,23`; `app/views/doorkeeper/authorizations/new.html.erb:46,68,74` | `lang="en"`, `Sure Authorization`, `Authorizing...`, `Denying...`, celý souhlas `By authorizing…` | dynamické `lang`; `Oprávnění aplikace Sure`; `Probíhá autorizace…`; `Probíhá zamítnutí…`; lokalizovaný souhlas přes `t()` | OAuth autorizační/souhlasová obrazovka | **major** — bezpečnostně významný souhlas je smíšeně česko-anglický |
| H-06 | `app/views/invite_codes/_invite_code.html.erb:16` | `Are you sure?` / stejná angličtina | `Opravdu chcete tento pozvánkový kód odstranit?` přes existující či nový klíč | destruktivní potvrzení | **major** — uživatelské potvrzení mimo i18n |
| H-07 | `app/views/mercury_items/setup_accounts.html.erb:1`; `app/views/lunchflow_items/setup_accounts.html.erb:1` | `Set Up Mercury Accounts`; `Set Up Lunch Flow Accounts` | použít již lokalizovaný titul dané obrazovky, např. `Nastavení účtů Mercury` / `Nastavení účtů Lunch Flow` | `<title>`/page title modálního nastavení | **minor** — hlavní nadpis je přeložen, ale titul dokumentu zůstává anglický |

`app/views/layouts/lookbooks.html.erb` (`Component Preview`) nebyl označen jako produktová chyba: jde o vývojářský Lookbook, nikoli koncové UI. Stejně nebyly chybně označeny značky, tickery, ISO kódy, IBKR názvy konfiguračních polí, certifikátové hlavičky, klávesy `Esc`, URL ani ukázkové technické identifikátory.

# Runtime/UI risks

## R-01 — Neřízený průchod technických chyb do českého UI

- **Cesta / klíč:** `app/jobs/process_pdf_job.rb:53-60` + `imports.pdf_import.processing_failed_with_message/processing_failed_generic`; `app/models/sso_provider_tester.rb:93,184-186` + `sso_provider.connection_failed/error`; reprezentativně též `app/controllers/transactions_controller.rb:319-322`.
- **Anglický originál:** zpráva výjimky či název třídy (`error.message`, `ReadTimeout`, provider message).
- **Současný CS:** český rámec s nezměněnou dynamickou zprávou, např. `Zpracování se nezdařilo: %{error}` nebo `Připojení se nezdařilo: %{error}`.
- **Doporučení:** technický detail ukládat do `DebugLogEntry`; uživateli zobrazit stabilní lokalizovanou kategorii a případně bezpečný kód chyby. Provider text propouštět jen po explicitní mapě bezpečných/lokalizovaných zpráv.
- **Vysvětlení:** Statická analýza nemůže zaručit jazyk ani bezpečnost dynamické zprávy. U `process_pdf_job` je navíc uživateli posílán přímo text `RuntimeError`/`ArgumentError`; u jiné větve jméno Ruby třídy.
- **Kontext:** PDF import, SSO test a konverze transakce.
- **Závažnost:** **major runtime riziko**, nikoli potvrzený anglický výstup pro každou chybu.

## R-02 — Skutečné rozložení a přístupnost nebyly vizuálně ověřeny ve všech stavech

Automatické testy ověřily vykreslení a funkce, ne však ořezání delších českých textů, všechny breakpointy, systémové fonty, focus order ani výslovnost čtečkou obrazovky. `UI_QA_MATRIX.md` je plán/předchozí záznam, nikoli důkaz v tomto nezávislém běhu. Před vydáním je nutné projít zejména dashboard, detail pozice, provider setupy, import PDF/CSV, SSO/OAuth, tisk a mobilní hromadné akce v češtině.

## R-03 — Auditovaný fork není aktuální upstream

Referenční commit je o 296 commitů za `upstream/main` ke dni auditu. Není bezpečné instalovat tento překlad nad novější Sure bez nového diffu katalogů, call-site a migrací. Toto není chyba překladu revize `66ffc034`, ale release/údržbové riziko.

## R-04 — Testy nechrání nalezené chyby

Celý Rails suite je zelený, ale neobsahuje aserci pro `recurring_transactions.expected_in` s 5/21 ani pro dynamický `<html lang>`. Stávající pluralizační test kontroluje 0, 1, 2, 3, 4, 5, 11, 21 a dvě necelá `BigDecimal`, nikoli viditelné `1.0/2.0/5.0`; navíc neověřuje konkrétní vadný klíč. Mobilní lokalizační test naopak stále očekává starší českou formulaci obecné chyby, ačkoli katalog byl změněn na přirozenější text.

## R-05 — Mobilní testovací sada není zelená ani po oddělení chyby překladu od chyby testu

- **Cesta / klíč:** `mobile/test/l10n/czech_localization_test.dart:77-89`; `mobile/lib/l10n/app_cs.arb:1550`, `clientErrorUnexpected`; vedle toho kompilační místa popsaná v C-01.
- **Anglický originál:** `Something went wrong. Please try again.`
- **Současný CS:** katalog i generovaná třída obsahují `Něco se pokazilo. Zkuste to prosím znovu.`, zatímco test očekává `Došlo k neočekávané chybě. Zkuste to znovu.`
- **Doporučení:** Ponechat přirozenější katalogové znění a aktualizovat očekávání testu; následně opravit C-01 a ostatní nezávislá selhání mobilní sady. Test generovaných lokalizací spouštět po každé změně ARB.
- **Vysvětlení:** Cílený soubor dokončil 5 testů úspěšně a 1 selhal pouze kvůli zastaralé přesné aserci. Celá sada na projektové verzi Flutter 3.32.4 skončila stavem `+175 -6`; kromě této aserce obsahovala tři kompilační místa z C-01 a další nesouvisející problémy testů/kontraktů (`SureButton`, token fixture, `AuthService`). Překlad `clientErrorUnexpected` je významově věrný a přirozený; chybný je zde testovací kontrakt.
- **Kontext:** fallback při neznámém nebo anglickém detailu klientské chyby a stav mobilního release gate.
- **Závažnost:** **major testovací/release riziko**; samotná současná česká věta je správná.

# Tests performed

| kontrola | výsledek |
|---|---|
| Načtení všech požadovaných dokumentů | `STYLE_GUIDE.md`, `GLOSSARY.csv`, `DECISIONS.md`, `SOURCES.md`, `QA_REPORT.md`, `UI_QA_MATRIX.md`, lokalizační `README.md` přečteny; QA report použit jen jako tvrzení |
| Kontextový audit zdrojů | klíče dohledávány v Ruby, ERB, JS/TS, Dart a Rustu; hardcoded scan oddělil UI text od značek/identifikátorů |
| Rails EN/CS struktura | 141 párů; 7 769/7 769 normalizovaných hodnot; 0 chybějících a 0 přebývajících klíčů |
| YAML parser / duplicity | všechny auditované YAML načteny; 0 duplicitních mapovacích klíčů |
| Rails interpolace | 0 skutečných neshod názvů nebo počtu výskytů po branch-aware porovnání |
| `i18n-tasks missing -l cs` | nástroj vypsal 13 statických kandidátů; ruční kontrola call-site potvrdila falešné pozitivní nálezy z relativního `t(".key")` uvnitř privátních metod — za běhu se scope odvozuje od volající controller action a příslušné české klíče existují |
| HTML/odkazy v překladech | 0 neshod množiny značek; 0 neshod `href`/`src` |
| Rails plural groups | 211/211 má `one/few/many/other`; následná jazyková kontrola odhalila M-01 a N-05 |
| Cílený Rails test | `bin/rails test test/lib/czech_pluralization_test.rb`: 2 testy, 14 asercí, 0 selhání |
| Vlastní Rails plural matrix | spuštěny všechny požadované hodnoty + `BigDecimal("1.0")`, `("2.0")`, `("5.0")`; výsledky jsou v sekci Pluralization review |
| Přímý runtime vadného klíče | potvrzeno: 5 → `Očekáváno za 5 dne`, 21 → `Očekáváno za 21 dne` |
| Celý Rails suite | PostgreSQL 17 + Redis 7, `SELF_HOSTED=false`: 6 122 testů, 24 347 asercí, 0 selhání, 0 chyb, 30 přeskočeno |
| První neplatný Rails běh | s chybně zadaným `SELF_HOSTED=true`: 43 selhání feature-gate/rate-limit testů; výsledek nebyl použit pro hodnocení a běh byl korektně zopakován |
| RuboCop | 2 185 souborů, 0 prohřešků |
| Biome lint | 109 souborů, bez oprav a bez nálezů; spuštěno přes přesnou dostupnou verzi `1.9.4` se systémovým CA |
| ARB | validní JSON, 380 EN + 380 CS message keys, 0 missing/extra; tři plural messages mají všechny čtyři české větve |
| Celý Flutter suite | přesná projektová verze Flutter 3.32.4 / Dart 3.8.1, `flutter pub get --enforce-lockfile`, izolovaná kopie read-only mountu `mobile/`: výsledek `+175 -6`, tedy 175 úspěšných a 6 neúspěšných; mezi příčinami jsou tři kompilační místa C-01, zastaralá česká aserce a další nesouvisející testovací/zdrojové problémy |
| Cílený Flutter lokalizační test | `test/l10n/czech_localization_test.dart`: 5 úspěšných, 1 neúspěšný; jediný rozdíl je staré očekávání `Došlo k neočekávané chybě…` proti aktuálnímu správnému katalogu `Něco se pokazilo…` |
| Desktop | `tsc --noEmit && vite build` prošlo; 15 modulů; build výstup byl veden mimo repozitář |
| Nativní Tauri/Rust | nespouštěno: host nemá Cargo/Rust a frontend build neověřuje nativní menu na všech OS |
| `git diff --check` | spuštěno nad jediným novým reportem před předáním; výsledek bez chyb |

Samostatný `i18n-tasks health` nad všemi 117 locale byl zastaven poté, co začal vypisovat 814 963 chybějících překladů napříč historicky neúplnými nečeskými jazyky; takový globální výsledek nevypovídá o úplnosti `cs`. Česká úplnost byla ověřena přímým EN/CS porovnáním a příslušné kontroly v plném Rails suite prošly.

# Recommended changes

1. **P0:** Opravit tři kompilační chyby mobilní lokalizační integrace z C-01 a vyžadovat zelený analyzátor, celý `flutter test` a release build.
2. **P0:** Opravit `recurring_transactions.expected_in` prohozením `many`/`other` a přidat testy alespoň pro 1, 2, 4, 5, 21 a desetinnou hodnotu.
3. **P0:** Přesunout všechny texty OAuth souhlasu a průběhových stavů do i18n; nastavit dynamický jazyk u hlavního, OAuth a tiskového HTML dokumentu.
4. **P0:** Lokalizovat account deletion, dashboard `aria-label`, invite-code confirm a dva provider page titles.
5. **P1:** Aktualizovat zastaralou aserci `clientErrorUnexpected` a odstranit zbývající nesouvisející selhání mobilního suite.
6. **P1:** Rozhodnout a implementovat kontrakt pro viditelná desetinná místa v Rails. Nelze ho opravit pouze jinou podmínkou nad `Float`; formátovaný počet a plurální kategorie musí vycházet ze stejné informace.
7. **P1:** Změnit „Účetní hodnotu“ na „Celkovou pořizovací hodnotu“ a současně opravit řádek 52 glosáře.
8. **P1:** Nahradit „vkladový účet“ v asistentské funkci a přidat `Depository account` do glosáře.
9. **P1:** Zamezit zobrazování neupravených `error.message`/názvů tříd v produkčním UI; detail směrovat do debug logu.
10. **P2:** Kontextově zjednodušit mechanické flash texty typu „bylo úspěšně…“, sjednotit jejich interpunkci a UX rozhodnout „volná hotovost“ vs. „volné peněžní prostředky“.
11. **P2:** Zpřesnit glosář u `bank account`, `payment`, `market value`, `purchase price` a `loan`; zákazy variant zapisovat jako kontextové, pokud nejsou skutečně absolutní.
12. **P2:** Po opravách aktualizovat `QA_REPORT.md`, lokalizační `README.md` a `UI_QA_MATRIX.md`; poté provést ruční české UI QA na podporovaných rozměrech a čtečce obrazovky.

Tento audit žádný existující překladový ani zdrojový soubor neupravil a nevytvořil commit. Jedinou změnou pracovního stromu je tento report.
