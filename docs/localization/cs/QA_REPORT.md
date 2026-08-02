# Zpráva o kvalitě české lokalizace

- **Stav:** dokončeno
- **Referenční upstream commit:** `5f0f5ec89d66beb04415e05853ef6930b0d46592`
- **Poslední aktualizace:** 2. 8. 2026

Kontrola zahrnuje Rails aplikaci, mobilní Flutter klient a desktopový Tauri
klient. Angličtina byla jediným strukturálním zdrojem; významy byly ověřovány
v modelech, kontrolerech, šablonách, testech a integračních tocích.

## Výsledek

- česká locale je mezi podporovanými jazyky;
- 140 párových katalogů `en.yml`/`cs.yml` má shodnou normalizovanou strukturu;
- oba Rails katalogy obsahují 7 678 normalizovaných hodnot;
- nebyl nalezen žádný chybějící ani neočekávaný český klíč;
- nebyla nalezena žádná neshoda interpolací;
- všech 210 pluralizačních skupin obsahuje požadované české větve;
- mobilní katalogy mají shodně 380 řetězců;
- desktopový katalog je typově vynucen přes `satisfies Record<AppLocale,
  DesktopStrings>` a produkční build prošel;
- všech 82 položek glosáře je po kontextové kontrole schváleno.

## Automatické kontroly

| Kontrola | Výsledek |
| --- | --- |
| Striktní načtení párových YAML bez duplicit | passed — 0 chyb |
| Shoda normalizovaných Rails klíčů | passed — 7 678/7 678 |
| Shoda interpolací Rails | passed — 0 neshod |
| České plurály `one/few/many/other` | passed — 210/210 skupin |
| Mobilní ARB klíče | passed — 380/380 |
| Mobilní ARB placeholdery | passed — 0 neshod |
| Cílený Rails regresní balík | passed — 170 testů, 953 kontrol |
| Celý Rails test suite | passed — 6 122 testů, 24 344 kontrol, 0 selhání, 30 přeskočeno |
| Produkční build desktopu | passed — TypeScript a Vite |
| `git diff --check` | passed — bez chyb whitespace |

Plný Rails suite byl spuštěn v izolovaném PostgreSQL 17 a Redis 7. Přeskočené
testy jsou podmíněné testy upstreamu; běh neobsahoval žádnou chybu ani
selhání.

## Jazyková a kontextová kontrola

- vykání, neutrální oslovování a větné psaní velkých písmen jsou jednotné;
- akční tlačítka používají přirozený infinitiv a popisné texty úplné věty;
- `Family` se pro uživatele překládá jako „domácnost“, ne mechanicky jako
  „rodina“;
- finanční účet, uživatelský účet a externí připojení jsou významově
  rozlišeny;
- majetek, závazky, dluh a čisté jmění nejsou zaměňovány;
- APR kreditní karty není nesprávně označeno jako RPSN;
- obecné množství investičních nástrojů nepředpokládá, že jde vždy o akcie;
- nezaúčtovaná a zaúčtovaná transakce nejsou zaměněny s obecným čekajícím
  stavem;
- převod mezi účty a platba na účet představující závazek mají odlišné
  názvy;
- obchodník, příjemce a obchodník od poskytovatele mají odlišné významy;
- stabilní tickery, MIC, názvy značek, typy aktivit a API identifikátory
  zůstávají beze změny;
- surové chyby poskytovatelů se nezobrazují jako anglický fallback;
- česká typografie používá správné uvozovky, výpustku, pomlčku a pevné mezery
  u číselných hodnot.

## Opravené technické problémy odhalené při QA

- mobilní parser již nekorumpuje české částky s desetinnou čárkou a respektuje
  počet desetinných míst měny;
- mobilní webový úvod a neznámé klientské chyby již nemají natvrdo zapsanou
  angličtinu;
- Rails importní validace nepoužívá rezervovaný interpolační název `format`,
  který způsoboval HTTP 500;
- soukromé metody Sophtronu znovu používají správný kontext překladových
  klíčů;
- výchozí názvy transakcí IBKR a Trading 212 jsou lokalizované, zatímco
  stabilní interní hodnoty zůstaly anglické;
- chyby CoinStats a IBKR jsou bezpečné a lokalizované;
- přístupné popisky ikonových a segmentovaných ovladačů mají české klíče.

## Omezení prostředí

Přesný nový Docker build podle aktuálního `Gemfile.lock` nebylo možné stáhnout,
protože proxy Docker Desktopu nepřijala certifikát RubyGems. Testy proto běžely
nad aktuálním zdrojovým stromem v kompatibilním již ověřeném obrazu Rails
8.1.3; aktuální lock používá Rails 8.1.3.1. Aplikace se v tomto obrazu načetla,
databáze se připravila a celý test suite prošel.

V hostitelském prostředí není Flutter ani Dart SDK. Mobilní widget testy proto
nebylo možné spustit; shoda ARB katalogů, placeholderů, signatur generovaných
lokalizací a volání v Dart zdrojích byla ověřena staticky. Připravené mobilní
testy je nutné nechat proběhnout v běžném mobilním CI.
