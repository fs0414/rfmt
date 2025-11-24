use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Config {
    pub parser: ParserConfig,
    pub formatting: FormattingConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ParserConfig {
    pub version: String,
    pub error_tolerance: bool,
    pub encoding: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FormattingConfig {
    pub line_length: usize,
    pub indent_style: IndentStyle,
    pub indent_width: usize,
    pub style: StyleConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum IndentStyle {
    Spaces,
    Tabs,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StyleConfig {
    pub quotes: QuoteStyle,
    pub hash_syntax: HashSyntax,
    pub trailing_comma: TrailingComma,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum QuoteStyle {
    Double,
    Single,
    Consistent,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum HashSyntax {
    Ruby19,
    HashRockets,
    Consistent,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TrailingComma {
    Always,
    Never,
    Multiline,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            parser: ParserConfig::default(),
            formatting: FormattingConfig::default(),
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
