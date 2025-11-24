pub mod prism_adapter;

use crate::ast::Node;
use crate::error::Result;

/// Prism parser adapter
pub use prism_adapter::PrismAdapter;

/// Parser trait for Ruby code
pub trait RubyParser: Send + Sync {
    fn parse(&self, source: &str) -> Result<Node>;
    fn name(&self) -> &'static str;
}