pub mod engine;
pub mod rules;

use crate::ast::Node;
use crate::config::Config;
use crate::error::Result;

pub use engine::FormatterEngine;

/// Formatter for Ruby code
pub struct Formatter {
    engine: FormatterEngine,
}

impl Formatter {
    pub fn new(config: Config) -> Self {
        Self {
            engine: FormatterEngine::new(config),
        }
    }

    pub fn format(&self, ast: Node) -> Result<Node> {
        self.engine.format(ast)
    }
}

impl Default for Formatter {
    fn default() -> Self {
        Self::new(Config::default())
    }
}
