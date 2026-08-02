export type AppLocale = "en" | "cs";

interface DesktopStrings {
  shell: {
    documentTitle: string;
    title: string;
    serverLabel: string;
    urlPlaceholder: string;
    connect: string;
    checking: string;
    unreachable: string;
    invalidUrl: string;
    remembered: string;
    remove: string;
  };
  preferences: {
    documentTitle: string;
    title: string;
    servers: string;
    add: string;
    launchAtLogin: string;
    switchTo: string;
  };
}

const translations = {
  en: {
    shell: {
      documentTitle: "Sure",
      title: "Connect to your Sure server",
      serverLabel: "Server address",
      urlPlaceholder: "https://sure.example.com",
      connect: "Continue",
      checking: "Checking server…",
      unreachable: "Couldn't reach a Sure server at that address.",
      invalidUrl: "That doesn't look like a valid address.",
      remembered: "Remembered servers",
      remove: "Remove",
    },
    preferences: {
      documentTitle: "Preferences",
      title: "Preferences",
      servers: "Servers",
      add: "Add",
      launchAtLogin: "Launch Sure at login",
      switchTo: "Switch to",
    },
  },
  cs: {
    shell: {
      documentTitle: "Sure",
      title: "Připojit k serveru Sure",
      serverLabel: "Adresa serveru",
      urlPlaceholder: "https://sure.example.com",
      connect: "Pokračovat",
      checking: "Ověřování serveru…",
      unreachable: "K serveru Sure se na této adrese nepodařilo připojit.",
      invalidUrl: "Tato adresa není platná.",
      remembered: "Uložené servery",
      remove: "Odebrat",
    },
    preferences: {
      documentTitle: "Nastavení",
      title: "Nastavení",
      servers: "Servery",
      add: "Přidat",
      launchAtLogin: "Spouštět Sure po přihlášení",
      switchTo: "Přepnout na",
    },
  },
} as const satisfies Record<AppLocale, DesktopStrings>;

const storageKey = "sure.locale";

export function normalizeLocale(candidate: string | null | undefined): AppLocale | null {
  const language = candidate
    ?.trim()
    .toLowerCase()
    .split(/[-_.@]/, 1)[0];

  return language === "en" || language === "cs" ? language : null;
}

function storedLocale(): AppLocale | null {
  try {
    return normalizeLocale(globalThis.localStorage?.getItem(storageKey));
  } catch {
    return null;
  }
}

function systemLocaleCandidates(): readonly string[] {
  if (typeof navigator === "undefined") return [];
  return navigator.languages.length > 0 ? navigator.languages : [navigator.language];
}

export function resolveLocale(
  candidates: readonly string[] = systemLocaleCandidates(),
): AppLocale {
  const saved = storedLocale();
  if (saved) return saved;

  for (const candidate of candidates) {
    const locale = normalizeLocale(candidate);
    if (locale) return locale;
  }

  return "en";
}

export const locale = resolveLocale();
export const S = translations[locale].shell;
export const P = translations[locale].preferences;

export function localizeDocument(title: string): void {
  document.documentElement.lang = locale;
  document.title = title;

  try {
    globalThis.localStorage?.setItem(storageKey, locale);
  } catch {
    // A restricted webview can deny storage; the in-memory locale still works.
  }
}
