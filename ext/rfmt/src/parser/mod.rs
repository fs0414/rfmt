use crate::ast::Node;
use crate::error::Result;

pub mod prism_adapter;
pub use prism_adapter::PrismAdapter;

pub trait RubyParser: Send + Sync {
    fn parse(&self, source: &str) -> Result<Node>;
}
