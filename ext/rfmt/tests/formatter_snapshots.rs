use rfmt::config::Config;
use rfmt::format::Formatter;
use rfmt::parser::{NativeAdapter, RubyParser};

fn format_ruby(source: &str) -> String {
    let ast = NativeAdapter::new()
        .parse(source)
        .expect("failed to parse Ruby source");

    Formatter::new(Config::default())
        .format(source, &ast)
        .expect("failed to format Ruby source")
}

#[test]
fn snapshot_simple_class() {
    insta::assert_snapshot!(format_ruby("class Foo\nend"));
}

#[test]
fn snapshot_class_with_superclass() {
    insta::assert_snapshot!(format_ruby("class Child < Parent\nend"));
}

#[test]
fn snapshot_simple_module() {
    insta::assert_snapshot!(format_ruby("module MyModule\nend"));
}

#[test]
fn snapshot_simple_method() {
    insta::assert_snapshot!(format_ruby("def hello\n  42\nend"));
}

#[test]
fn snapshot_method_with_params() {
    insta::assert_snapshot!(format_ruby("def greet(name)\n  puts name\nend"));
}

#[test]
fn snapshot_if_statement() {
    insta::assert_snapshot!(format_ruby("if x > 0\n  puts \"positive\"\nend"));
}

#[test]
fn snapshot_case_when() {
    insta::assert_snapshot!(format_ruby("case x\nwhen 1\n  :one\nelse\n  :other\nend"));
}

#[test]
fn snapshot_while_loop() {
    insta::assert_snapshot!(format_ruby("while x > 0\n  x -= 1\nend"));
}
