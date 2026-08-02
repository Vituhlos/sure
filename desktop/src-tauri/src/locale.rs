use std::path::PathBuf;
#[cfg(target_os = "macos")]
use std::process::Command;

const LOCALE_FILE: &str = "locale";

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum AppLocale {
    En,
    Cs,
}

impl AppLocale {
    pub fn code(self) -> &'static str {
        match self {
            Self::En => "en",
            Self::Cs => "cs",
        }
    }

    pub fn parse(candidate: &str) -> Option<Self> {
        let normalized = candidate
            .trim()
            .trim_matches(|character: char| !character.is_ascii_alphanumeric())
            .split(|character| matches!(character, '-' | '_' | '.' | '@'))
            .next()?
            .to_ascii_lowercase();

        match normalized.as_str() {
            "en" => Some(Self::En),
            "cs" => Some(Self::Cs),
            _ => None,
        }
    }
}

pub struct NativeStrings {
    pub preferences: &'static str,
    pub switch_server: &'static str,
    pub file: &'static str,
    pub edit: &'static str,
    pub reload: &'static str,
    pub view: &'static str,
    pub window: &'static str,
    pub preferences_title: &'static str,
}

pub fn strings(locale: AppLocale) -> NativeStrings {
    match locale {
        AppLocale::En => NativeStrings {
            preferences: "Preferences…",
            switch_server: "Switch Server…",
            file: "File",
            edit: "Edit",
            reload: "Reload",
            view: "View",
            window: "Window",
            preferences_title: "Preferences",
        },
        AppLocale::Cs => NativeStrings {
            preferences: "Nastavení…",
            switch_server: "Přepnout server…",
            file: "Soubor",
            edit: "Úpravy",
            reload: "Znovu načíst",
            view: "Zobrazení",
            window: "Okno",
            preferences_title: "Nastavení",
        },
    }
}

fn locale_path() -> Option<PathBuf> {
    Some(crate::servers::data_dir()?.join(LOCALE_FILE))
}

fn saved_locale() -> Option<AppLocale> {
    let value = std::fs::read_to_string(locale_path()?).ok()?;
    AppLocale::parse(&value)
}

fn system_locale() -> AppLocale {
    #[cfg(target_os = "macos")]
    if let Ok(output) = Command::new("defaults")
        .args(["read", "-g", "AppleLanguages"])
        .output()
    {
        if output.status.success() {
            let languages = String::from_utf8_lossy(&output.stdout);
            for line in languages.lines() {
                if let Some(locale) = AppLocale::parse(line) {
                    return locale;
                }
            }
        }
    }

    for variable in ["LC_ALL", "LC_MESSAGES", "LANGUAGE", "LANG"] {
        if let Some(locale) = std::env::var_os(variable) {
            for candidate in locale.to_string_lossy().split(':') {
                if let Some(locale) = AppLocale::parse(candidate) {
                    return locale;
                }
            }
        }
    }

    AppLocale::En
}

pub fn load() -> AppLocale {
    saved_locale().unwrap_or_else(system_locale)
}

pub fn save(locale: AppLocale) -> Result<(), String> {
    let path =
        locale_path().ok_or_else(|| "application support directory unavailable".to_string())?;
    let temporary_path = path.with_extension("tmp");
    std::fs::write(&temporary_path, locale.code()).map_err(|error| error.to_string())?;
    std::fs::rename(temporary_path, path).map_err(|error| error.to_string())
}

#[cfg(test)]
mod tests {
    use super::AppLocale;

    #[test]
    fn parses_supported_language_variants() {
        assert_eq!(AppLocale::parse("cs-CZ"), Some(AppLocale::Cs));
        assert_eq!(AppLocale::parse("\"cs_CZ\","), Some(AppLocale::Cs));
        assert_eq!(AppLocale::parse("en_US.UTF-8"), Some(AppLocale::En));
    }

    #[test]
    fn rejects_unsupported_languages_instead_of_guessing() {
        assert_eq!(AppLocale::parse("sk-SK"), None);
        assert_eq!(AppLocale::parse(""), None);
    }
}
