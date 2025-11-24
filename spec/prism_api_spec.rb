# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Prism API compatibility" do
  it "uses expected Prism version" do
    expect(Prism::VERSION).to match(/^1\.6/)
  end

  describe "node classes existence" do
    it "has ProgramNode" do
      expect(defined?(Prism::ProgramNode)).to be_truthy
    end

    it "has ClassNode" do
      expect(defined?(Prism::ClassNode)).to be_truthy
    end

    it "has DefNode" do
      expect(defined?(Prism::DefNode)).to be_truthy
    end

    it "has CallNode" do
      expect(defined?(Prism::CallNode)).to be_truthy
    end

    it "has StringNode" do
      expect(defined?(Prism::StringNode)).to be_truthy
    end
  end

  describe "ClassNode API" do
    let(:source) { "class Foo < Bar; end" }
    let(:class_node) { Prism.parse(source).value.statements.body.first }

    it "responds to name" do
      expect(class_node).to respond_to(:name)
    end

    it "responds to superclass" do
      expect(class_node).to respond_to(:superclass)
    end

    it "responds to body" do
      expect(class_node).to respond_to(:body)
    end

    it "responds to constant_path" do
      expect(class_node).to respond_to(:constant_path)
    end
  end

  describe "DefNode API" do
    let(:source) { "def foo(a, b); end" }
    let(:def_node) { Prism.parse(source).value.statements.body.first }

    it "responds to name" do
      expect(def_node).to respond_to(:name)
    end

    it "responds to parameters" do
      expect(def_node).to respond_to(:parameters)
    end

    it "responds to body" do
      expect(def_node).to respond_to(:body)
    end

    it "parameters has child_nodes method" do
      expect(def_node.parameters).to respond_to(:child_nodes) if def_node.parameters
    end
  end

  describe "CallNode API" do
    let(:source) { "foo.bar(1, 2)" }
    let(:call_node) { Prism.parse(source).value.statements.body.first }

    it "responds to name" do
      expect(call_node).to respond_to(:name)
    end

    it "responds to message" do
      expect(call_node).to respond_to(:message)
    end

    it "responds to receiver" do
      expect(call_node).to respond_to(:receiver)
    end

    it "responds to arguments" do
      expect(call_node).to respond_to(:arguments)
    end
  end

  describe "StringNode API" do
    let(:source) { '"hello"' }
    let(:string_node) { Prism.parse(source).value.statements.body.first }

    it "responds to content" do
      expect(string_node).to respond_to(:content)
    end
  end

  describe "IntegerNode API" do
    let(:source) { "42" }
    let(:integer_node) { Prism.parse(source).value.statements.body.first }

    it "responds to value" do
      expect(integer_node).to respond_to(:value)
    end
  end

  describe "location information" do
    let(:source) { "puts 'hello'" }
    let(:node) { Prism.parse(source).value }

    it "has location method" do
      expect(node).to respond_to(:location)
    end

    it "location has required properties" do
      loc = node.location
      expect(loc).to respond_to(:start_line)
      expect(loc).to respond_to(:start_column)
      expect(loc).to respond_to(:end_line)
      expect(loc).to respond_to(:end_column)
      expect(loc).to respond_to(:start_offset)
      expect(loc).to respond_to(:end_offset)
    end
  end
end
