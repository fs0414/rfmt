use crate::ast::Node;
use crate::error::Result;
use crate::formatter::engine::FormatContext;

/// Priority for rule application
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Priority {
    High = 3,
    Normal = 2,
    Low = 1,
}

/// Trait for formatting rules
pub trait FormattingRule: Send + Sync {
    /// Name of the rule
    fn name(&self) -> &str;

    /// Priority of the rule
    fn priority(&self) -> Priority;

    /// Check if rule is applicable to a node
    fn applicable(&self, node: &Node) -> bool;

    /// Apply the rule to a node
    fn apply(&self, node: Node, context: &FormatContext) -> Result<Node>;
}

/// Collection of formatting rules
pub struct RuleSet {
    rules: Vec<Box<dyn FormattingRule>>,
}

impl RuleSet {
    pub fn new() -> Self {
        Self { rules: Vec::new() }
    }

    pub fn add_rule(&mut self, rule: Box<dyn FormattingRule>) {
        self.rules.push(rule);
    }

    /// Get rules sorted by priority
    pub fn iter_sorted(&self) -> impl Iterator<Item = &Box<dyn FormattingRule>> {
        let mut rules = self.rules.iter().collect::<Vec<_>>();
        rules.sort_by(|a, b| b.priority().cmp(&a.priority()));
        rules.into_iter()
    }
}

impl Default for RuleSet {
    fn default() -> Self {
        Self::new()
    }
}
