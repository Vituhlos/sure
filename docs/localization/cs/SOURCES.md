# Zdroje české lokalizace

- **Stav:** schválený seznam
- **Poslední kontrola odkazů a obsahu:** 2. 8. 2026

Tento soubor eviduje zdroje použité pro jazyková a terminologická rozhodnutí.
Identifikátory v hranatých závorkách se používají ve `GLOSSARY.csv` a
`DECISIONS.md`.

## Priorita zdrojů

1. Zdrojový kód určuje, co funkce v Sure skutečně znamená.
2. ČNB a české odborné zdroje určují finanční a bankovní význam.
3. ÚJČ určuje spisovnost, pravopis a českou typografii.
4. Unicode CLDR určuje lokalizační data a plurální kategorie.
5. Microsoft a Mozilla poskytují zásady pro přirozené české rozhraní.
6. Jiné překlady Sure slouží pouze jako kontextová pomůcka.

Novější nebo konkrétnější autoritativní pravidlo má přednost před starším či
obecným doporučením. Každá podstatná odchylka se zapisuje do
`DECISIONS.md`.

## Produkt a zdrojový kód

### [SURE]

- Zdroj: [we-promise/sure](https://github.com/we-promise/sure)
- Referenční commit:
  [`5f0f5ec89d66beb04415e05853ef6930b0d46592`](https://github.com/we-promise/sure/commit/5f0f5ec89d66beb04415e05853ef6930b0d46592)
- Použití: význam řetězců, názvy modelů, pracovní postupy, místo použití,
  interpolace a technická omezení.
- Poznámka: před každým překladovým celkem se musí ověřit aktuální upstream.
  Anglický text může být sám o sobě nejasný; rozhoduje implementace a chování.

### [SURE-PL]

- Zdroj: polské soubory v referenční revizi repozitáře Sure.
- Použití: vedlejší kontrola kontextu, členění souborů a detekce zvláštních
  případů.
- Omezení: polská lokalizace není úplná ani normativní a nesmí být zdrojem
  českého překladu.

## Český jazyk a typografie

### [UJC]

- Zdroj: [Internetová jazyková příručka ÚJČ AV ČR](https://prirucka.ujc.cas.cz/)
- Použití: pravopis, tvarosloví, interpunkce a typografie.
- Dílčí hesla:
  - [Kalendářní datum](https://prirucka.ujc.cas.cz/?id=810)
  - [Časové údaje](https://prirucka.ujc.cas.cz/?id=820)
  - [Uvozovky](https://prirucka.ujc.cas.cz/?id=162)
  - [Pomlčka](https://prirucka.ujc.cas.cz/?id=165)
  - [Spojovník](https://prirucka.ujc.cas.cz/?id=164)
- Poznámka: pro jednotnost digitálního rozhraní manuál volí čas s dvojtečkou,
  který příručka připouští.

### [MOZ-CS]

- Zdroj: [Mozilla Czech Localization Style Guide](https://mozilla-l10n.github.io/styleguides/cs/general.html)
- Použití: vykání, přirozené přeformulování, styl tlačítek, kapitalizace,
  české formáty a stručnost rozhraní.
- Převzaté principy: profesionální přátelský tón, malé `vy/váš`, infinitiv na
  krátkých akčních tlačítkách a významový překlad místo doslovnosti.

### [MS-CS]

- Zdroj:
  [Microsoft Czech Style Guide (PDF)](https://download.microsoft.com/download/7/b/5/7b57e4a1-d299-4238-9997-f3ac51d6f763/ces-cze-StyleGuide.pdf)
- Vstupní stránka:
  [Microsoft language style guides](https://learn.microsoft.com/globalization/reference/microsoft-style-guides)
- Kontrolovaná revize PDF: metadata dokumentu uvádějí změnu 5. 9. 2024,
  65 stran.
- Použití: jasný, přátelský a stručný jazyk, neutrální oslovování, aktivní
  formulace, kapitalizace, jednotky a pevné mezery.
- Omezení: jde o obecný produktový manuál Microsoftu; pravidla ÚJČ, CLDR a
  konkrétní význam Sure mají přednost.

## Lokalizační data a plurály

### [CLDR-CS]

- Zdroj:
  [Unicode CLDR — Czech cardinal plural rules](https://unicode.org/cldr/charts/49/supplemental/language_plural_rules.html)
- Specifikace:
  [Unicode CLDR Plural Rules](https://cldr.unicode.org/index/cldr-spec/plural-rules)
- Doplňující česká gramatická data:
  [CLDR Czech grammar](https://www.unicode.org/cldr/charts/49/grammar/cs.html)
- Použití: kategorie `one`, `few`, `many`, `other`, české formáty a
  lokalizační chování.
- Klíčové pravidlo: `many` označuje v češtině desetinné hodnoty; nula a celá
  čísla od pěti spadají do `other`.

### [RAILS-I18N]

- Zdroj:
  [rails-i18n — WestSlavic pluralization](https://github.com/svenfuchs/rails-i18n/blob/34be758a2748b0a7c99c90838d387276c4d97bf2/lib/rails_i18n/common_pluralizations/west_slavic.rb)
- Použití: ověření skutečného pluralizačního chování závislosti používané
  projektem.
- Zjištění: implementace nabízí jen `one`, `few` a `other`; českou kategorii
  `many` pro desetinná čísla je nutné v Sure doplnit nebo jinak výslovně
  vyřešit a otestovat.

## Finanční a bankovní terminologie

### [CNB-ACCOUNTS]

- Zdroj:
  [ČNB — Statistika finančních účtů](https://www.cnb.cz/cs/statistika/stat-fin-uctu/index.html)
- Použití: finanční účet, transakce, aktiva, závazky, rozvaha a finanční
  nástroje.

### [CNB-BALANCE]

- Zdroj:
  [ČNB — Finanční účet platební bilance: metodické principy a datové zdroje](https://www.cnb.cz/cs/o_cnb/cnblog/Financni-ucet-platebni-bilance-metodicke-principy-a-datove-zdroje/)
- Použití: rozlišení aktiv, závazků/pasiv, pozic a finančních transakcí v
  odborném kontextu.

### [CNB-PAYMENTS]

- Zdroj:
  [ČNB — Přístup k obohaceným datům o platebním účtu](https://www.cnb.cz/cs/dohled-financni-trh/legislativni-zakladna/stanoviska-k-regulaci-financniho-trhu/RS2025-12)
- Použití: platební účet, zůstatek, historie platebních transakcí, příjemce a
  obchodník.

### [CNB-RECURRING]

- Zdroj:
  [ČNB — české znění dokumentu ECB k pojmům platebních služeb](https://www.cnb.cz/export/sites/cnb/cs/statistika/.galleries/menova_bankovni_stat/mbs_mezinarodni_dokumenty/ecb_2020_2011_cz.pdf)
- Použití: oficiální český ekvivalent pojmu `recurring transaction` jako
  „opakující se transakce“.
- Kontrola: 29. 7. 2026.

### [CNB-CREDIT]

- Zdroj:
  [ČNB — Spotřebitelský úvěr](https://www.cnb.cz/cs/dohled-financni-trh/ochrana-spotrebitele/spotrebitelsky-uver/index.html)
- Použití: úvěr, úvěr na bydlení, jistina a úrok.

### [CFPB-APR]

- Zdroj:
  [Consumer Financial Protection Bureau — What does credit card APR mean?](https://www.consumerfinance.gov/ask-cfpb/what-is-a-credit-card-interest-rate-what-does-apr-mean-en-44/)
- Použití: význam pole `APR` u kreditní karty jako úrokové sazby vyjádřené
  ročně.
- Kontrola: 28. 7. 2026.

### [CNB-RPSN]

- Zdroj:
  [ČNB — Co je ukazatel RPSN?](https://www.cnb.cz/cs/casto-kladene-dotazy/Co-je-ukazatel-RPSN)
- Použití: odlišení české RPSN, která vyjadřuje celkové náklady
  spotřebitelského úvěru, od úrokové sazby kreditní karty.
- Kontrola: 28. 7. 2026.

### [CNB-INVEST]

- Zdroj:
  [ČNB — Modelová portfolia investičních nástrojů](https://www.cnb.cz/cs/dohled-financni-trh/legislativni-zakladna/stanoviska-k-regulaci-financniho-trhu/RS2024-01/)
- Použití: portfolio, cenný papír, investiční nástroj, aktivum, výnos a
  rebalancování.

### [CNB-DIGITAL-ASSETS]

- Zdroj:
  [ČNB — První testovací portfolio digitálních aktiv](https://www.cnb.cz/cs/o_cnb/cnblog/Prvni-testovaci-portfolio-digitalnich-aktiv-v-CNB)
- Použití: kryptoaktiva, ETF, portfolio a pořizovací hodnota.
- Kontrola: 28. 7. 2026.

### [CNB-BOOK-VALUE]

- Zdroj:
  [ČNB — Přehled účetních postupů a finančních výkazů](https://www.cnb.cz/export/sites/cnb/cs/o_cnb/.galleries/hospodareni/download/ruz_1995_cz_ias.pdf)
- Použití: odlišení účetní a tržní hodnoty investic.
- Kontrola: 28. 7. 2026.

### [CNB-ESA]

- Zdroj:
  [ČNB — Evropský systém účtů ESA 2010](https://www.cnb.cz/export/sites/cnb/cs/statistika/.galleries/stat_fin_uctu/download/ESA2010_cz.pdf)
- Použití: význam realizovaných a nerealizovaných zisků a ztrát.
- Kontrola: 28. 7. 2026.

## Údržba zdrojů

- Odkazy a platnost rozhodujících tvrzení se kontrolují při každé větší
  jazykové revizi.
- U proměnlivých online zdrojů se zaznamená datum kontroly.
- Změna upstreamu se nesmí automaticky promítnout do slovníku; nejprve se
  zkontroluje, zda se nezměnil význam funkce.
- Nový zdroj dostane stabilní identifikátor a stručné vymezení použití.
