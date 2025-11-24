# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Rfmt Formatter' do
  describe 'basic formatting' do
    it 'formats a simple class' do
      input = "class Foo\nend"
      result = Rfmt.format(input)

      expect(result).to eq("class Foo\nend")
    end

    it 'formats a class with superclass' do
      input = "class User < ApplicationRecord\nend"
      result = Rfmt.format(input)

      expect(result).to eq("class User < ApplicationRecord\nend")
    end

    it 'formats nested classes with proper indentation' do
      input = "class Outer\nclass Inner\nend\nend"
      result = Rfmt.format(input)

      expected = "class Outer\n  class Inner\n  end\nend"
      expect(result).to eq(expected)
    end

    it 'formats a module' do
      input = "module Foo\nend"
      result = Rfmt.format(input)

      expect(result).to eq("module Foo\nend")
    end

    it 'formats a method' do
      input = "def foo\nend"
      result = Rfmt.format(input)

      expect(result).to eq("def foo\nend")
    end
  end

  describe 'indentation' do
    it 'indents method inside class' do
      input = "class Foo\ndef bar\nend\nend"
      result = Rfmt.format(input)

      expected = "class Foo\n  def bar\n  end\nend"
      expect(result).to eq(expected)
    end

    it 'indents nested structures' do
      input = "class A\nclass B\ndef method\nend\nend\nend"
      result = Rfmt.format(input)

      expected = "class A\n  class B\n    def method\n    end\n  end\nend"
      expect(result).to eq(expected)
    end

    it 'handles deep nesting' do
      input = "module M\nclass A\nclass B\ndef foo\nend\nend\nend\nend"
      result = Rfmt.format(input)

      expected = "module M\n  class A\n    class B\n      def foo\n      end\n    end\n  end\nend"
      expect(result).to eq(expected)
    end
  end

  describe 'method body preservation' do
    it 'preserves simple method body' do
      input = <<~RUBY
        class Foo
        def bar
        puts "hello"
        end
        end
      RUBY

      result = Rfmt.format(input)

      expect(result).to include('puts "hello"')
    end

    it 'preserves method with parameters' do
      input = <<~RUBY
        def greet(name, age)
        puts "Hello"
        end
      RUBY

      result = Rfmt.format(input)

      expect(result).to include('greet(name, age)')
      expect(result).to include('puts "Hello"')
    end

    it 'handles method with single parameter correctly' do
      input = <<~RUBY
        class User
        def initialize(name)
        @name = name
        end
        end
      RUBY

      result = Rfmt.format(input)

      expected = <<~RUBY
        class User
          def initialize(name)
            @name = name
          end
        end
      RUBY

      expect(result).to eq(expected.strip)
    end
  end

  describe 'idempotency' do
    it 'produces same result when formatted twice' do
      input = "class Foo\ndef bar\nend\nend"

      first_format = Rfmt.format(input)
      second_format = Rfmt.format(first_format)

      expect(first_format).to eq(second_format)
    end

    it 'is idempotent for nested structures' do
      input = "module M\nclass A\ndef foo\nend\nend\nend"

      first_format = Rfmt.format(input)
      second_format = Rfmt.format(first_format)

      expect(first_format).to eq(second_format)
    end
  end

  describe 'complex code' do
    it 'handles class with multiple methods' do
      input = <<~RUBY
        class User
        def initialize(name)
        @name = name
        end
        def greet
        puts "Hi"
        end
        end
      RUBY

      result = Rfmt.format(input)

      expect(result).to include('class User')
      expect(result).to include('def initialize(name)')
      expect(result).to include('def greet')
      expect(result).to include('end')
    end
  end

  describe 'error handling' do
    it 'raises error on invalid Ruby' do
      input = "class Foo\n" # Unclosed class

      expect { Rfmt.format(input) }.to raise_error(Rfmt::Error)
    end
  end
end
