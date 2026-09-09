# Lokalizační manuál pro češtinu

- **Stav:** schválený závazný základ
- **Jazyk:** čeština (`cs`)
- **Referenční upstream commit:** `5f0f5ec89d66beb04415e05853ef6930b0d46592`
- **Poslední revize:** 2. 8. 2026

Tento manuál je závazný pro webovou aplikaci, e-maily, texty vyvolané úlohami
na pozadí, mobilní aplikaci i desktopového klienta Sure. Jeho cílem není
doslovná shoda s angličtinou, ale přesné a přirozené vyjádření stejného
významu v konkrétním kontextu.

## 1. Pořadí autorit

Při rozporu se postupuje v tomto pořadí:

1. skutečný význam a použití textu ve zdrojovém kódu Sure;
2. česká odborná terminologie ČNB, účetnictví a bankovnictví;
3. pravidla ÚJČ AV ČR;
4. česká data Unicode CLDR;
5. doporučení českých lokalizačních příruček Microsoftu a Mozilly;
6. zavedené vzorce v ostatních kvalitních lokalizacích Sure.

Jiný překlad není autoritou pro český význam. Polská lokalizace může odhalit
kontext nebo zvláštní větev, ale nesmí se mechanicky kopírovat.

## 2. Základní zásady

- Překládá se význam v rozhraní, nikoli izolovaný anglický řetězec.
- Každý nejasný řetězec se před překladem dohledá ve zdrojovém kódu.
- Čeština musí znít jako původní text, ne jako překlad.
- Upřednostňuje se současný, stručný a srozumitelný jazyk před úřednickými
  konstrukcemi a anglickými kalky.
- Finanční přesnost má přednost před doslovností i módním názvoslovím.
- Stejný pojem se překládá konzistentně, pokud rozdílný kontext nevyžaduje
  jiný ekvivalent.
- Nejasnost se zapisuje do `DECISIONS.md`; nesmí se vyřešit náhodným odhadem.
- Strojově vytvořený návrh není hotový překlad. Každý řetězec musí projít
  kontextovou a jazykovou revizí.

## 3. Tón a oslovování

Sure komunikuje profesionálně, klidně, přátelsky a věcně. Uživateli vyká:

- používá druhou osobu množného čísla: „Zkontrolujte připojení.“;
- zájmena `vy`, `vám`, `váš` se uvnitř věty píší s malým písmenem;
- nepersonifikuje aplikaci a zbytečně nepoužívá první osobu;
- nevyvolává paniku; chyba má popsat problém a nabídnout další krok;
- používá neutrální konstrukce, pokud není znám rod osoby nebo objektu.

Nevhodné:

- „Jste si jistý/á, že chcete účet smazat?“
- „Omlouváme se, ale něco se pokazilo!“
- „Sure pro vás našel nové transakce.“

Vhodné:

- „Opravdu chcete účet smazat?“
- „Něco se nepodařilo. Zkuste to znovu.“
- „Byly nalezeny nové transakce.“

## 4. Styl podle prvku rozhraní

### Tlačítka a krátké akce

Používá se infinitiv, zpravidla jedno až tři slova:

- `Save` → „Uložit“
- `Add account` → „Přidat účet“
- `Try again` → „Zkusit znovu“

Výjimkou jsou ustálené krátké odpovědi, například „Ano“, „Ne“, „Zpět“ nebo
„Hotovo“. Dvojznačné obecné popisky jako „OK“, „Pokračovat“ či „Odeslat“ se
nahrazují konkrétní akcí, dovoluje-li to zdrojový klíč.

### Nadpisy, položky nabídek a štítky

- Používá se větné psaní velkých písmen: „Nastavení účtu“, nikoli
  „Nastavení Účtu“.
- Nadpis je stručný a bez tečky.
- Položky nabídky a názvy polí jsou zpravidla podstatná jména nebo krátká
  jmenná spojení: „Datum transakce“, „Dostupné kategorie“.
- Zavedené zkratky a vlastní názvy si ponechávají původní kapitalizaci.

### Pokyny, chyby a potvrzení

- Pokyn, který vyžaduje činnost uživatele, používá zdvořilý rozkaz:
  „Vyberte účet.“
- Chyba odpoví pokud možno na tři otázky: co se nepodařilo, proč, co lze
  udělat dál.
- Potvrzení popisuje dokončený výsledek: „Účet byl přidán.“ Pokud by věta
  vyžadovala neznámý rod, použije se neutrální varianta: „Přidáno: %{name}.“
- Destruktivní dialog pojmenuje objekt i následek. Obecné „Jste si jistí?“ se
  nepoužívá.
- V prázdném stavu se stručně vysvětlí stav a nabídne smysluplná další akce.

### Nápovědy a tooltipy

Nápověda doplňuje informaci, neopakuje pouze popisek. Tooltip ovládacího prvku
popisuje jeho účinek činným tvarem ve třetí osobě, například „Zobrazí
podrobnosti“, „Uloží změny“ nebo „Otevře nabídku“. Text musí být srozumitelný i
bez vizuální polohy prvku.

### Zaškrtávací políčka a přepínače

Popisky voleb ve stejné skupině musí být gramaticky rovnocenné. Samostatná
akční volba zpravidla používá infinitiv („Zahrnout nezaúčtované transakce“).
Pokud popisek navazuje na úvodní větu nebo otázku, všechny volby ji musí
doplňovat stejným větným způsobem.

## 5. Rod a dynamické hodnoty

Rod uživatele se nepředpokládá a nepoužívají se lomítkové podoby
`přihlášen/a`, závorky `uživatel(ka)` ani generické mužské příčestí tam, kde
označuje konkrétní osobu.

U dynamického názvu neznámého rodu se věta přeformuluje:

- nevhodně: „%{name} byl odstraněn.“
- vhodně: „Odstraněno: %{name}.“
- vhodně: „Položku %{name} se nepodařilo odstranit.“

Pokud je rod objektu jednoznačný z klíče a nemůže se za běhu změnit, je běžná
česká shoda žádoucí: „Transakce byla odstraněna.“

## 6. Velká písmena a interpunkce

- Používá se větné psaní velkých písmen.
- Tlačítka, samostatné štítky, položky nabídek a nadpisy nemají na konci tečku.
- Úplné věty v popisech, chybách, potvrzeních a nápovědě mají koncovou
  interpunkci.
- Dvojtečka se píše bez mezery před ní a s mezerou za ní.
- Česká typografická uvozovka je `„…“`; vnořená je `‚…‘`.
- Spojovník `-` spojuje výrazy. Pomlčka `–` odděluje části výpovědi a značí
  rozsah.
- Rozsah se zapisuje pomlčkou bez okolních mezer: `1. 1.–31. 3. 2026`.
- Tři tečky se zapisují znakem výpustky `…`, nikoli třemi tečkami. V popisku
  akce se používají jen tehdy, pokud akce skutečně otevře další dialog nebo
  vyžaduje další údaj.
- Typografické znaky se nesmějí vkládat do technických identifikátorů, kódu,
  URL, e-mailových adres ani zástupných proměnných.

## 7. Čísla, částky, měny a procenta

- Desetinným oddělovačem je čárka: `1 234,56`.
- Delší čísla se člení trojicemi pomocí pevné mezery: `12 345 678`.
- Mezi číslem a jednotkou, symbolem procent nebo označením měny je pevná
  mezera: `25 %`, `1 250 Kč`, `99,90 EUR`.
- Měnové kódy ISO 4217 (`CZK`, `EUR`, `USD`) se nepřekládají.
- Pro českou korunu se používá `Kč`; zápis `500,-` se nepoužívá.
- Záporné znaménko, zaokrouhlení, počet desetinných míst a umístění měny se
  mají řídit lokalizovaným formátovačem. Přeložený řetězec nesmí ručně
  duplikovat znak měny.
- V technických datových formátech, importních šablonách, API a kódu se
  zachovává formát požadovaný daným rozhraním, i když není typograficky český.

Pevnou mezerou se rozumí nedělitelná mezera vhodná pro dané výstupní
prostředí. V HTML může být výsledkem formátovače nebo entity, v prostém textu
znak U+00A0. Nesmí se svévolně měnit uvnitř interpolace.

## 8. Datum a čas

- Číselné datum má podobu `d. m. rrrr`, například `28. 7. 2026`.
- Dlouhé datum má podobu `28. července 2026`.
- Rok se nezkracuje, pokud to výslovně nevyžaduje stísněný grafický prvek.
- Používá se 24hodinový čas. Pro jednotnost rozhraní se volí zápis `14:05`.
- Rozsah času se zapisuje `9:00–11:30`.
- Prvním dnem týdne je pondělí.
- Názvy dnů a měsíců se v běžném českém textu píší s malým písmenem.
- Relativní údaje jako „dnes“ a „včera“ se používají jen tehdy, pokud je
  časové pásmo a okamžik zobrazení jednoznačný.

## 9. České plurály

Základem jsou kardinální kategorie Unicode CLDR:

| Kategorie | Použití v češtině | Příklad |
| --- | --- | --- |
| `one` | celé číslo 1 | `1 transakce` |
| `few` | celá čísla 2–4 | `3 transakce` |
| `many` | desetinné číslo; tvar odpovídá desetinné číslovce | `1,5 transakce`, `1,5 dne` |
| `other` | 0 a celá čísla 5 a více | `0 transakcí`, `12 transakcí` |

Pravidla:

- Český překlad musí mít větve `one`, `few`, `many` a `other`, pokud řetězec
  přijímá obecnou číselnou hodnotu.
- Kategorie `zero` není českou plurální kategorií CLDR. Zvláštní text pro nulu
  je přípustný pouze jako záměrná produktová větev.
- Ve všech větvích se zachovává stejná množina interpolací jako v anglickém
  zdroji. Je-li ve zdroji `%{count}`, zůstane i v české větvi `one`.
- Anglické pořadí slov ani anglická plurální větev neurčují český pád.
- Podstatné jméno se řídí skutečnou větou, nejen číslem. Po předložce může být
  vyžadován jiný pád.
- `many` není univerzální „množné číslo“. Po desetinné číslovce jde v
  základním spojení často o 2. pád jednotného čísla (`1,5 dne`); u některých
  rodů může být výsledný tvar graficky shodný s větví `few`
  (`3 transakce`, `1,5 transakce`).

Současná pluralizace gemu `rails-i18n` pro západoslovanské jazyky směruje
desetinná čísla do `other` a kategorii `many` nenabízí. Před aktivací češtiny
se proto musí doplnit a otestovat české pravidlo odpovídající CLDR. Flutter
ARB musí používat stejné významové kategorie ve formátu ICU. Rails přijímá
číselnou hodnotu, nikoli původní textový zápis, takže implementace musí mít
výslovně otestované chování celočíselných a desetinných typů. Pokud produkční
formátovač odstraňuje nevýznamné koncové nuly, například `1,0` zobrazuje jako
`1`, smí pluralizace vycházet z této viditelné celočíselné hodnoty. Obecnou
podporu CLDR pro viditelná desetinná místa však lze deklarovat jen tehdy,
pokud call-site zachová i operand `v` nebo rovnocennou informaci.

## 10. Zástupné proměnné a formátovací syntaxe

- Názvy, velikost písmen, počet výskytů a syntaxe proměnných se nikdy
  nepřekládají: `%{name}`, `%{count}`, `{amount}`.
- Přesun proměnné je dovolen, vyžaduje-li jej český slovosled.
- Každá česká varianta musí obsahovat přesně stejnou množinu proměnných jako
  odpovídající anglická varianta.
- Zachovávají se formátovací specifikátory, únikové sekvence, zástupné značky
  ICU, Markdownu a šablonovacího systému.
- Proměnná se nesmí rozdělit mezerou ani českým typografickým znakem.
- Interpolovaný obsah se nepředpokládá jako bezpečné HTML a nesmí se obcházet
  existující escapování.

Před přijetím změny musí automatická kontrola porovnat proměnné anglického a
českého řetězce včetně každé plurální větve.

## 11. HTML, Markdown a odkazy

- Zachovávají se všechny značky, atributy, pořadí vnoření, odkazy a technické
  identifikátory, pokud změnu nevyžaduje samotná funkcionalita.
- Překládá se viditelný text a uživatelské textové atributy jako `title`,
  `aria-label` a vhodný alternativní text.
- URL, fragmenty odkazů, názvy cest, CSS třídy a datové atributy se
  nepřekládají.
- Značka se nesmí přesunout tak, aby změnila rozsah odkazu nebo zdůraznění.
- Česká věta se může přeformulovat a text rozdělit mezi značky jinak pouze po
  ověření výsledného DOM a významu.
- Markdownové odkazy zachovávají cíl; překládá se jejich čitelný popisek.
- HTML řetězce se kontrolují parserem nebo vykreslením, ne pouze vizuálním
  porovnáním zdrojového YAML.

## 12. Produkty, značky a nepřekládané výrazy

Nepřekládají se:

- název produktu `Sure`;
- názvy externích poskytovatelů a značek;
- tickerové symboly, kódy měn, MIC, IBAN a identifikátory;
- názvy protokolů a zavedené zkratky jako API, CSV, PDF, OAuth a SSO;
- názvy souborů, příkazy, proměnné prostředí, URL a úseky kódu.

Odborné anglické slovo se ponechá jen tehdy, je-li v češtině skutečně
ustálené nebo jde o název funkce třetí strany. Běžné pojmy jako `account`,
`transaction`, `holding` nebo `provider` se anglicky neponechávají.

Při prvním použití méně známé zkratky v delším textu se uvede české vysvětlení,
pokud to prostor a kontext dovolují. Zkratky se neskloňují přidáváním
anglických koncovek.

## 13. Přístupnost

- `aria-label` popisuje účel nebo akci prvku, nikoli jeho vzhled:
  „Zavřít dialog“, nikoli „Křížek“.
- Alternativní text sděluje význam obrázku v daném kontextu; nezačíná
  automaticky slovem „Obrázek“.
- Dekorativní obrázek má prázdný alternativní text, pokud to odpovídá
  implementaci.
- Text nesmí rozlišovat stav jen barvou, polohou nebo směrem typu „tlačítko
  napravo“.
- Popisky ovládacích prvků musí být jednoznačné i bez okolního vizuálního
  kontextu.
- Stejná akce má v textu na obrazovce a v přístupném názvu stejnou
  terminologii.
- Překlad nesmí odstranit nápovědu pro čtečku ani vložit emoji jako jediný
  nositel významu.

## 14. Délka textů

Závazný maximální limit není stanoven jedním počtem znaků, protože stejný počet
má podle písmen, písma, zařízení a zvětšení odlišnou šířku. Maximální přípustná
délka je taková, která zachová celý význam a vejde se do podporovaného prvku
bez překrytí nebo neřízeného oříznutí při nejmenší podporované šířce a při
zvětšení textu na 200 %. Pokud se přirozený překlad nevejde, musí se upravit
komponenta nebo schválit konkrétní kratší varianta; význam se nesmí bez
rozhodnutí vypustit.

Dále platí:

- význam a přirozenost mají přednost před mechanickým zkrácením;
- tlačítko má být zpravidla dlouhé jedno až tři slova;
- nadpis má být co nejkratší, ale jednoznačný;
- český text se bez ověření nesmí zkracovat neustálenou zkratkou;
- delší překlad se musí vyzkoušet v nejmenší podporované šířce, při zvětšení
  textu a na mobilním rozložení;
- oříznutí, překrytí nebo ztráta významu je chyba rozhraní, nikoli důvod pro
  nepřirozený překlad.

Konkrétní prostorové výjimky se zapisují do `DECISIONS.md` a ověřují v
`UI_QA_MATRIX.md`.

## 15. Terminologie finančního rozhraní

Závazné ekvivalenty jsou vedeny v `GLOSSARY.csv`. Obecně:

- uživatelsky srozumitelný název má přednost před zbytečným účetnickým
  odborným výrazem;
- odborný termín se použije tam, kde Sure skutečně zobrazuje odbornou veličinu;
- `liability` se v osobních financích překládá „závazek“, ne automaticky
  „pasivum“;
- `pending transaction` znamená bankou dosud nezaúčtovanou transakci;
- `reconciliation` má podle funkce nejméně tři rozdílné překlady a nesmí se
  sjednotit bez
  kontroly kontextu;
- `return` je u investic „výnos“ nebo „výnosnost“, nikoli automaticky
  „návratnost“.

## 16. Pracovní postup pro každý celek

1. Aktualizovat informace o `upstream/main` a zaznamenat referenční commit.
2. Vymezit logický celek, například účty nebo import.
3. Porovnat anglické klíče se skutečným použitím v Ruby, ERB, TypeScriptu,
   Rustu nebo Dart/Flutter kódu.
4. Zapsat nové pojmy a nejasnosti před překladem.
5. Přeložit související řetězce společně, nikoli abecedicky bez kontextu.
6. Zkontrolovat YAML/ARB syntaxi, klíče, interpolace, HTML a plurály.
7. Provést jazykovou revizi bez pohledu na anglickou větnou stavbu.
8. Ověřit text v běžícím rozhraní a zapsat výsledek do QA dokumentů.

Angličtina je významový zdroj. Český překlad se nikdy nemá „opravovat“ jen
proto, aby připomínal polskou nebo jinou lokalizaci.

## 17. Kontrola před přijetím překladu

Každý celek musí projít alespoň těmito kontrolami:

- úplnost klíčů vůči angličtině;
- žádné přebytečné nebo osiřelé klíče;
- shoda interpolací a ICU parametrů;
- platný YAML a ARB;
- všechny potřebné české plurální větve;
- zachované a platné HTML/Markdown struktury;
- vyhledání nezáměrně ponechané angličtiny;
- kontrola proti schválenému slovníku;
- typografie čísel, měn, procent, data a času;
- čtení českého textu samostatně bez anglické předlohy;
- kontextové ověření na desktopu i úzkém rozlišení;
- u e-mailů kontrola předmětu, textové i HTML varianty;
- u úloh na pozadí ověření správného locale uživatele nebo rodiny.

Výjimka je přípustná pouze s konkrétním odůvodněním v `DECISIONS.md`.
