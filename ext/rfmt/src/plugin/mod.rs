use crate::ast::Node;
use crate::error::Result;
use crate::formatter::rules::FormattingRule;

/// Plugin trait for extending rfmt functionality
pub trait Plugin: Send + Sync {
    /// Plugin name
    fn name(&self) -> &str;

    /// Plugin version
    fn version(&self) -> Version;

    /// Initialize the plugin
    fn initialize(&mut self, context: &PluginContext) -> Result<()>;

    /// Get formatting rules provided by this plugin
    fn rules(&self) -> Vec<Box<dyn FormattingRule>>;

    /// Hook called before formatting
    fn on_before_format(&self, _ast: &mut Node) -> Result<()> {
        Ok(())
    }

    /// Hook called after formatting
    fn on_after_format(&self, _ast: &mut Node) -> Result<()> {
        Ok(())
    }
}

/// Plugin context
pub struct PluginContext {
    // TODO: Add context fields as needed
}

impl PluginContext {
    pub fn new() -> Self {
        Self {}
    }
}

impl Default for PluginContext {
    fn default() -> Self {
        Self::new()
    }
}

/// Version information
#[derive(Debug, Clone)]
pub struct Version {
    pub major: u32,
    pub minor: u32,
    pub patch: u32,
}

impl Version {
    pub fn new(major: u32, minor: u32, patch: u32) -> Self {
        Self {
            major,
            minor,
            patch,
        }
    }
}

impl std::fmt::Display for Version {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}.{}.{}", self.major, self.minor, self.patch)
    }
}

/// Plugin registry
pub struct PluginRegistry {
    plugins: Vec<Box<dyn Plugin>>,
}

impl PluginRegistry {
    pub fn new() -> Self {
        Self {
            plugins: Vec::new(),
        }
    }

    pub fn register(&mut self, plugin: Box<dyn Plugin>) {
        self.plugins.push(plugin);
    }

    pub fn plugins(&self) -> &[Box<dyn Plugin>] {
        &self.plugins
    }
}

impl Default for PluginRegistry {
    fn default() -> Self {
        Self::new()
    }
}
