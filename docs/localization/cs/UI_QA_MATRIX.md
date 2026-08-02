# Matice kontextové kontroly českého rozhraní

- **Stav:** dokončeno
- **Referenční upstream commit:** `5f0f5ec89d66beb04415e05853ef6930b0d46592`
- **Poslední revize:** 2. 8. 2026

`passed` znamená, že byly společně zkontrolovány zdrojový kontext, překladové
klíče, interpolace, plurály a relevantní testy. Vizuální chování Rails pokrývá
vykreslení v integračních testech; mobilní kontrola je kvůli absenci Flutter
SDK v QA prostředí statická a testy byly připraveny pro následné spuštění v
prostředí s Flutterem.

| Funkční celek | Rails | Mobil | Desktop | Kontrolované oblasti | Stav |
| --- | --- | --- | --- | --- | --- |
| Jazyk a locale | ano | ano | ano | volba jazyka, hlavičky API, fallback, názvy jazyků | passed |
| Formátování | ano | ano | ano | datum, čas, čísla, procenta, měny, pevné mezery | passed |
| Registrace a přihlášení | ano | ano | ne | registrace, heslo, OIDC/SSO, 2FA, WebAuthn | passed |
| Onboarding | ano | ano | ne | domácnost, měna, cíle, zkušební období | passed |
| Navigace a společné prvky | ano | ano | ano | nabídky, dialogy, tooltipy, patička, přístupné názvy | passed |
| Přehled | ano | ano | ano | čisté jmění, aktiva, závazky, období, soukromý režim | passed |
| Finanční účty | ano | ano | ano | vytvoření, úprava, typy, zůstatky, synchronizace | passed |
| Bankovní účty a karty | ano | ano | ne | podtypy, dostupný úvěr, APR, splátky | passed |
| Úvěry a ostatní závazky | ano | ano | ne | jistina, sazby, splatnost, platby | passed |
| Nemovitosti a vozidla | ano | ano | ne | ocenění, adresa, plocha, nájezd, jednotky | passed |
| Investice a kryptoaktiva | ano | ano | ne | pozice, obchody, množství, tickery, výnos | passed |
| Transakce | ano | ano | ne | příjmy, výdaje, filtry, dělení, přílohy | passed |
| Převody a platby | ano | ano | ne | obě strany převodu, závazkové účty, párování | passed |
| Kategorie a obchodníci | ano | ano | ne | výchozí názvy, slučování, poskytovatelé | passed |
| Štítky a pravidla | ano | částečně | ne | operátory, akce, stabilní interní hodnoty | passed |
| Rozpočty a přehledy | ano | ano | ne | období, souhrny, grafy, prázdné stavy | passed |
| Cíle a plánování | ano | ano | ne | cíle, příspěvky, projekce, validace | passed |
| Importy a exporty | ano | ne | ne | CSV/QIF/PDF/Sure, mapování, diagnostika, chyby | passed |
| Poskytovatelé | ano | ano | ano | propojení, přihlášení, MFA, synchronizace, chyby | passed |
| AI asistent | ano | ano | ne | pozdravy, nástroje, chyby, názvy objektů | passed |
| Nastavení a administrace | ano | ano | ano | profil, domácnost, API klíče, hosting, ladění | passed |
| E-maily a oznámení | ano | ano | ano | předmět, HTML/text, pravidla, systémová oznámení | passed |
| Chybové a prázdné stavy | ano | ano | ano | bezpečné obecné chyby, žádný únik surové angličtiny | passed |

## Zvlášť ověřené rizikové scénáře

- české plurály `one/few/many/other`, včetně desetinných hodnot;
- částky `1 234,56`, záporné hodnoty a měny bez dvou desetinných míst;
- lokalizace spuštěná v úloze na pozadí a v maileru;
- přepínání jazyka bez změny uložených API a providerových hodnot;
- uživatelský „účet“ versus finanční účet a externí připojení;
- „domácnost“ versus interní model `Family`;
- „nezaúčtovaná“ versus „zaúčtovaná“ transakce;
- „převod“ versus platba na účet představující závazek;
- „jednotka“ u obecného investičního nástroje versus konkrétní akcie;
- bezpečné chyby CoinStats, IBKR, SimpleFIN, Sophtron a Trading 212;
- importní validační hlášky bez rezervovaných interpolačních názvů;
- přístupné popisky segmentovaných ovladačů a ikonových akcí;
- mobilní webový úvod bez natvrdo zapsané angličtiny.

## Omezení vizuální kontroly

V tomto QA prostředí není nainstalováno Flutter SDK, proto zde nebylo možné
spustit widget testy ani pořídit mobilní screenshoty. ARB katalog, Dart
signatury, parametry, plurály a všechna volání překladů byly zkontrolovány
staticky; příslušné testy jsou součástí změn. Toto omezení nemění zjištěnou
strukturální ani jazykovou úplnost, ale je nutné je zopakovat v mobilním CI.
