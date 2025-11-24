# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rfmt::PrismNodeExtractor do
  # Create a test class that includes the module
  let(:test_class) do
    Class.new do
      extend Rfmt::PrismNodeExtractor
    end
  end

  describe ".extract_node_name" do
    it "extracts name from a class node" do
      source = "class Foo; end"
      result = Prism.parse(source)
      class_node = result.value.statements.body.first

      name = test_class.extract_node_name(class_node)
      expect(name).to eq("Foo")
    end

    it "returns nil for node without name" do
      source = "42"
      result = Prism.parse(source)
      integer_node = result.value.statements.body.first

      name = test_class.extract_node_name(integer_node)
      expect(name).to be_nil
    end
  end

  describe ".extract_superclass_name" do
    it "extracts superclass from ConstantReadNode" do
      source = "class Foo < Bar; end"
      result = Prism.parse(source)
      class_node = result.value.statements.body.first

      superclass_name = test_class.extract_superclass_name(class_node)
      expect(superclass_name).to eq("Bar")
    end

    it "returns nil when superclass is nil" do
      source = "class Foo; end"
      result = Prism.parse(source)
      class_node = result.value.statements.body.first

      superclass_name = test_class.extract_superclass_name(class_node)
      expect(superclass_name).to be_nil
    end

    it "handles node without superclass method" do
      source = "42"
      result = Prism.parse(source)
      integer_node = result.value.statements.body.first

      superclass_name = test_class.extract_superclass_name(integer_node)
      expect(superclass_name).to be_nil
    end
  end

  describe ".extract_parameter_count" do
    it "extracts parameter count from method with parameters" do
      source = "def foo(a, b, c); end"
      result = Prism.parse(source)
      def_node = result.value.statements.body.first

      count = test_class.extract_parameter_count(def_node)
      expect(count).to eq(3)
    end

    it "returns 0 for method without parameters" do
      source = "def foo; end"
      result = Prism.parse(source)
      def_node = result.value.statements.body.first

      count = test_class.extract_parameter_count(def_node)
      expect(count).to eq(0)
    end

    it "returns 0 for node without parameters method" do
      source = "42"
      result = Prism.parse(source)
      integer_node = result.value.statements.body.first

      count = test_class.extract_parameter_count(integer_node)
      expect(count).to eq(0)
    end
  end

  describe ".extract_message_name" do
    it "extracts message name from call node" do
      source = "foo.bar"
      result = Prism.parse(source)
      call_node = result.value.statements.body.first

      message = test_class.extract_message_name(call_node)
      expect(message).to eq("bar")
    end

    it "returns nil for node without message" do
      source = "42"
      result = Prism.parse(source)
      integer_node = result.value.statements.body.first

      message = test_class.extract_message_name(integer_node)
      expect(message).to be_nil
    end
  end

  describe ".extract_string_content" do
    it "extracts content from string node" do
      source = '"hello world"'
      result = Prism.parse(source)
      string_node = result.value.statements.body.first

      content = test_class.extract_string_content(string_node)
      expect(content).to eq("hello world")
    end

    it "returns nil for node without content" do
      source = "42"
      result = Prism.parse(source)
      integer_node = result.value.statements.body.first

      content = test_class.extract_string_content(integer_node)
      expect(content).to be_nil
    end
  end

  describe ".extract_literal_value" do
    it "extracts value from integer node" do
      source = "42"
      result = Prism.parse(source)
      integer_node = result.value.statements.body.first

      value = test_class.extract_literal_value(integer_node)
      expect(value).to eq("42")
    end

    it "extracts value from float node" do
      source = "3.14"
      result = Prism.parse(source)
      float_node = result.value.statements.body.first

      value = test_class.extract_literal_value(float_node)
      expect(value).to eq("3.14")
    end

    it "extracts value from symbol node" do
      source = ":hello"
      result = Prism.parse(source)
      symbol_node = result.value.statements.body.first

      value = test_class.extract_literal_value(symbol_node)
      expect(value).to eq("hello")
    end

    it "returns nil for node without value" do
      source = "class Foo; end"
      result = Prism.parse(source)
      class_node = result.value.statements.body.first

      value = test_class.extract_literal_value(class_node)
      expect(value).to be_nil
    end
  end
end
