use super::{Node, NodeType};
use crate::error::Result;

/// Visitor pattern for AST traversal
pub trait Visitor {
    /// Visit a node and then recursively visit its children
    fn visit_node(&mut self, node: &Node) -> Result<()> {
        // Visit current node based on type
        match &node.node_type {
            NodeType::ProgramNode => self.visit_program(node)?,
            NodeType::ClassNode => self.visit_class(node)?,
            NodeType::ModuleNode => self.visit_module(node)?,
            NodeType::DefNode => self.visit_method(node)?,
            NodeType::CallNode => self.visit_call(node)?,
            NodeType::IfNode => self.visit_if(node)?,
            NodeType::UnlessNode => self.visit_unless(node)?,
            NodeType::StringNode => self.visit_string(node)?,
            NodeType::IntegerNode => self.visit_integer(node)?,
            NodeType::FloatNode => self.visit_float(node)?,
            NodeType::ArrayNode => self.visit_array(node)?,
            NodeType::HashNode => self.visit_hash(node)?,
            NodeType::BlockNode => self.visit_block(node)?,
            _ => self.visit_other(node)?,
        }

        // Visit children
        for child in &node.children {
            self.visit_node(child)?;
        }

        Ok(())
    }

    fn visit_program(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_class(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_module(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_method(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_call(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_if(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_unless(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_string(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_integer(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_float(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_array(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_hash(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_block(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }

    fn visit_other(&mut self, _node: &Node) -> Result<()> {
        Ok(())
    }
}

/// Mutable visitor for AST transformation
pub trait VisitorMut {
    /// Visit a node mutably and then recursively visit its children
    fn visit_node_mut(&mut self, node: &mut Node) -> Result<()> {
        // Visit current node based on type
        match &node.node_type {
            NodeType::ProgramNode => self.visit_program_mut(node)?,
            NodeType::ClassNode => self.visit_class_mut(node)?,
            NodeType::ModuleNode => self.visit_module_mut(node)?,
            NodeType::DefNode => self.visit_method_mut(node)?,
            NodeType::CallNode => self.visit_call_mut(node)?,
            NodeType::IfNode => self.visit_if_mut(node)?,
            NodeType::UnlessNode => self.visit_unless_mut(node)?,
            NodeType::StringNode => self.visit_string_mut(node)?,
            NodeType::IntegerNode => self.visit_integer_mut(node)?,
            NodeType::FloatNode => self.visit_float_mut(node)?,
            NodeType::ArrayNode => self.visit_array_mut(node)?,
            NodeType::HashNode => self.visit_hash_mut(node)?,
            NodeType::BlockNode => self.visit_block_mut(node)?,
            _ => self.visit_other_mut(node)?,
        }

        // Visit children
        for child in &mut node.children {
            self.visit_node_mut(child)?;
        }

        Ok(())
    }

    fn visit_program_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_class_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_module_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_method_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_call_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_if_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_unless_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_string_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_integer_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_float_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_array_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_hash_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_block_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }

    fn visit_other_mut(&mut self, _node: &mut Node) -> Result<()> {
        Ok(())
    }
}
