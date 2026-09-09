# Matice kontextové kontroly českého rozhraní

- **Stav:** automatická a zdrojová kontrola dokončena
- **Auditovaná výchozí revize:** `66ffc034b4ba2ce0bd3c23627b7edf75c504e91e`
- **Poslední revize:** 9. 9. 2026

`passed` znamená, že byly společně zkontrolovány zdrojový kontext,
překladové klíče, interpolace, plurály a dostupné relevantní testy. Neznamená
to ruční vizuální průchod každou variantou obrazovky na fyzickém zařízení.

| Funkční celek | Rails | Mobil | Desktop | Kontrolované oblasti | Stav |
| --- | --- | --- | --- | --- | --- |
| Jazyk a locale | ano | ano | ano | volba jazyka, HTML `lang`, hlavičky API, fallback, názvy jazyků | passed |
| Formátování | ano | ano | ano | datum, čas, čísla, procenta, měny, pevné mezery | passed |
| Registrace a přihlášení | ano | ano | ne | registrace, heslo, OIDC/SSO, 2FA, WebAuthn | passed |
| OAuth souhlas | ano | ne | ne | dynamický jazyk, oprávnění klienta, autorizace a zamítnutí | passed |
| Onboarding | ano | ano | ne | domácnost, měna, cíle, SSO, zkušební období | passed |
| Navigace a společné prvky | ano | ano | ano | nabídky, dialogy, tooltipy, patička, přístupné názvy | passed |
| Přehled | ano | ano | ano | čisté jmění, aktiva, závazky, řazení, soukromý režim | passed |
| Finanční účty | ano | ano | ano | vytvoření, úprava, typy, zůstatky, synchronizace | passed |
| Bankovní účty a karty | ano | ano | ne | podtypy, dostupný úvěr, APR, splátky | passed |
| Úvěry a ostatní závazky | ano | ano | ne | jistina, sazby, splatnost, platby | passed |
| Nemovitosti a vozidla | ano | ano | ne | ocenění, adresa, plocha, nájezd, jednotky | passed |
| Investice a kryptoaktiva | ano | ano | ne | pozice, pořizovací hodnota, obchody, množství, tickery | passed |
| Transakce | ano | ano | ne | příjmy, výdaje, filtry, dělení, přílohy | passed |
| Převody a platby | ano | ano | ne | obě strany převodu, závazkové účty, párování, bezpečné chyby | passed |
| Kategorie a obchodníci | ano | ano | ne | výchozí názvy, slučování, poskytovatelé | passed |
| Štítky a pravidla | ano | částečně | ne | operátory, akce, stabilní interní hodnoty | passed |
| Rozpočty a přehledy | ano | ano | ne | období, souhrny, grafy, prázdné stavy | passed |
| Cíle a plánování | ano | ano | ne | cíle, peněžní účty, projekce, validace | passed |
| Importy a exporty | ano | ne | ne | CSV/QIF/PDF/Sure, mapování, diagnostika, chyby | passed |
| Poskytovatelé | ano | ano | ano | propojení, přihlášení, MFA, synchronizace, chyby | passed |
| AI asistent | ano | ano | ne | pozdravy, nástroje, chyby, názvy objektů | passed |
| Nastavení a administrace | ano | ano | ano | profil, domácnost, API klíče, hosting, ladění | passed |
| E-maily a oznámení | ano | ano | ano | předmět, HTML/text, pravidla, systémová oznámení | passed |
| Chybové a prázdné stavy | ano | ano | ano | bezpečné obecné chyby, oddělená raw diagnostika | passed |

## Zvlášť ověřené rizikové scénáře

- české plurály včetně 1, 2, 4, 5, 21 a necelých investičních jednotek;
- shoda zobrazeného `1,5` s pluralizovaným tvarem „1,5 jednotky“;
- dynamické `<html lang="cs">` v hlavním, tiskovém a OAuth layoutu;
- lokalizovaný a bezpečnostně srozumitelný OAuth souhlas;
- klávesové řazení dashboardu a český přístupný návod;
- odlišení uživatelského, finančního, bankovního a obecného peněžního účtu;
- „Celková pořizovací hodnota“ vedle jednotkové pořizovací ceny;
- bezpečné uživatelské chyby s technickým detailem pouze v debug logu;
- přepínání jazyka bez změny uložených API a providerových hodnot;
- česká lokalizace mobilního klienta v kompletním Flutter suite.

## Omezení vizuální kontroly

Automatické widget testy byly spuštěny s Flutterem 3.32.4 a celý suite
prošel. Ruční screenshotová kontrola všech stavů na fyzickém telefonu ani
všech Rails obrazovek v prohlížeči součástí tohoto opravného běhu nebyla.
Sedm nesouvisejících nálezů `flutter analyze` je přesně popsáno v
`QA_REPORT.md`; žádný z nich není lokalizační compile error.
