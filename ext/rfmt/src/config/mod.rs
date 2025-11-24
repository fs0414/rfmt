use serde::{Deserialize, Serialize};

/// Complete configuration structure matching .rfmt.yml format
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Config {
    #[serde(default)]
    pub version: String,

    #[serde(default)]
    pub parser: ParserConfig,

    #[serde(default)]
    pub formatting: FormattingConfig,

    #[serde(default)]
    pub include: Vec<String>,

    #[serde(default)]
    pub exclude: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ParserConfig {
    pub version: String,
    pub error_tolerance: bool,
    pub encoding: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FormattingConfig {
    #[serde(default = "default_line_length")]
    pub line_length: usize,

    #[serde(rename = "indent_style", default)]
    pub indent_style: IndentStyle,

    #[serde(rename = "indent_width", default = "default_indent_width")]
    pub indent_width: usize,

    #[serde(rename = "quote_style", default)]
    pub quote_style: QuoteStyle,

    #[serde(default)]
    pub style: StyleConfig,
}

fn default_line_length() -> usize {
    100
}

fn default_indent_width() -> usize {
    2
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum IndentStyle {
    Spaces,
    Tabs,
}

impl Default for IndentStyle {
    fn default() -> Self {
        Self::Spaces
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StyleConfig {
    #[serde(default)]
    pub quotes: QuoteStyle,

    #[serde(default)]
    pub hash_syntax: HashSyntax,

    #[serde(default)]
    pub trailing_comma: TrailingComma,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum QuoteStyle {
    Double,
    Single,
    Consistent,
}

impl Default for QuoteStyle {
    fn default() -> Self {
        Self::Double
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum HashSyntax {
    Ruby19,
    HashRockets,
    Consistent,
}

impl Default for HashSyntax {
    fn default() -> Self {
        Self::Ruby19
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum TrailingComma {
    Always,
    Never,
    Multiline,
}

impl Default for TrailingComma {
    fn default() -> Self {
        Self::Multiline
    }
}

impl Config {
}

impl Default for Config {
    fn default() -> Self {
        Self {
            version: "1.0".to_string(),
            parser: ParserConfig::default(),
            formatting: FormattingConfig::default(),
            include: vec!["**/*.rb".to_string(), "**/*.rake".to_string()],
            exclude: vec![
                "vendor/**/*".to_string(),
                "tmp/**/*".to_string(),
                "node_modules/**/*".to_string(),
            ],
        }
    }
}

impl Default for ParserConfig {
    fn default() -> Self {
        Self {
            version: "latest".to_string(),
            error_tolerance: true,
            encoding: "UTF-8".to_string(),
        }
    }
}

impl Default for FormattingConfig {
    fn default() -> Self {
        Self {
            line_length: 100,
            indent_style: IndentStyle::Spaces,
            indent_width: 2,
            quote_style: QuoteStyle::Double,
            style: StyleConfig::default(),
        }
    }
}

impl Default for StyleConfig {
    fn default() -> Self {
        Self {
            quotes: QuoteStyle::Double,
            hash_syntax: HashSyntax::Ruby19,
            trailing_comma: TrailingComma::Multiline,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Write;
    use tempfile::NamedTempFile;

    #[test]
    fn test_default_config() {
        let config = Config::default();
        assert_eq!(config.version, "1.0");
        assert_eq!(config.formatting.line_length, 100);
        assert_eq!(config.formatting.indent_width, 2);
        assert!(matches!(
            config.formatting.indent_style,
            IndentStyle::Spaces
        ));
    }

    #[test]
    fn test_load_valid_config() {
        let yaml = r#"
version: "1.0"
formatting:
  line_length: 120
  indent_width: 4
  indent_style: tabs
  quote_style: single
include:
  - "**/*.rb"
exclude:
  - "vendor/**/*"
"#;

        let mut file = NamedTempFile::new().unwrap();
        file.write_all(yaml.as_bytes()).unwrap();
        file.flush().unwrap();

        let config = Config::load_file(file.path()).unwrap();
        assert_eq!(config.formatting.line_length, 120);
        assert_eq!(config.formatting.indent_width, 4);
        assert!(matches!(config.formatting.indent_style, IndentStyle::Tabs));
        assert!(matches!(config.formatting.quote_style, QuoteStyle::Single));
    }

    #[test]
    fn test_validate_line_length_too_small() {
        let yaml = r#"
formatting:
  line_length: 30
"#;

        let mut file = NamedTempFile::new().unwrap();
        file.write_all(yaml.as_bytes()).unwrap();
        file.flush().unwrap();

        let result = Config::load_file(file.path());
        assert!(result.is_err());
        if let Err(RfmtError::ConfigError { message, .. }) = result {
            assert!(message.contains("line_length"));
            assert!(message.contains("40 and 500"));
        }
    }

    #[test]
    fn test_validate_line_length_too_large() {
        let yaml = r#"
formatting:
  line_length: 600
"#;

        let mut file = NamedTempFile::new().unwrap();
        file.write_all(yaml.as_bytes()).unwrap();
        file.flush().unwrap();

        let result = Config::load_file(file.path());
        assert!(result.is_err());
    }

    #[test]
    fn test_validate_indent_width() {
        let yaml = r#"
formatting:
  indent_width: 10
"#;

        let mut file = NamedTempFile::new().unwrap();
        file.write_all(yaml.as_bytes()).unwrap();
        file.flush().unwrap();

        let result = Config::load_file(file.path());
        assert!(result.is_err());
        if let Err(RfmtError::ConfigError { message, .. }) = result {
            assert!(message.contains("indent_width"));
        }
    }

    #[test]
    fn test_indent_string_spaces() {
        let config = Config::default();
        assert_eq!(config.indent_string(), "  "); // 2 spaces
    }

    #[test]
    fn test_indent_string_tabs() {
        let mut config = Config::default();
        config.formatting.indent_style = IndentStyle::Tabs;
        assert_eq!(config.indent_string(), "\t");
    }

    #[test]
    fn test_should_include_basic() {
        let config = Config::default();
        assert!(config.should_include(Path::new("lib/foo.rb")));
        assert!(!config.should_include(Path::new("vendor/gem/foo.rb")));
    }

    #[test]
    fn test_should_include_with_exclude() {
        let mut config = Config::default();
        config.exclude.push("test/**/*".to_string());
        assert!(!config.should_include(Path::new("test/foo.rb")));
    }

    #[test]
    fn test_invalid_yaml_syntax() {
        let yaml = r#"
formatting:
  line_length: not_a_number
"#;

        let mut file = NamedTempFile::new().unwrap();
        file.write_all(yaml.as_bytes()).unwrap();
        file.flush().unwrap();

        let result = Config::load_file(file.path());
        assert!(result.is_err());
        if let Err(RfmtError::ConfigError { message, .. }) = result {
            assert!(message.contains("parse"));
        }
    }

    #[test]
    fn test_partial_config_uses_defaults() {
        let yaml = r#"
formatting:
  line_length: 80
"#;

        let mut file = NamedTempFile::new().unwrap();
        file.write_all(yaml.as_bytes()).unwrap();
        file.flush().unwrap();

        let config = Config::load_file(file.path()).unwrap();
        assert_eq!(config.formatting.line_length, 80);
        assert_eq!(config.formatting.indent_width, 2); // default
        assert!(matches!(
            config.formatting.indent_style,
            IndentStyle::Spaces
        )); // default
    }
}
