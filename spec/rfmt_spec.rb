# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rfmt do
  describe '.format' do
    it 'formats simple Ruby code' do
      source = <<~RUBY
        class Foo
        def bar
        42
        end
        end
      RUBY

      result = Rfmt.format(source)

      expect(result).to be_a(String)
      expect(result).to include('class Foo')
      expect(result).to include('def bar')
      expect(result).to include('end')
    end

    it 'raises error for invalid Ruby syntax' do
      invalid_source = 'class Foo def'

      expect do
        Rfmt.format(invalid_source)
      end.to raise_error(Rfmt::Error)
    end

    it 'formats Rails migration with versioned superclass' do
      source = <<~RUBY
        class AddProfileToUsers < ActiveRecord::Migration[8.1]
          def change
            add_column :users, :profile, :text
          end
        end
      RUBY

      result = Rfmt.format(source)

      expect(result).to include('class AddProfileToUsers < ActiveRecord::Migration[8.1]')
      expect(result).to include('def change')
      expect(result).not_to include('Prism::CallNode')
    end

    it 'formats method with required keyword parameters' do
      source = <<~RUBY
        def initialize(frame:, form:, tag_map:)
          @frame = frame
          @form = form
          @tag_map = tag_map
        end
      RUBY

      result = Rfmt.format(source)

      expect(result).to include('def initialize(frame:, form:, tag_map:)')
      expect(result).not_to match(/frame:\s+form:\s+tag_map:/)
      expect(result).to include('@frame = frame')
    end

    it 'formats method with optional keyword parameters' do
      source = <<~RUBY
        def configure(timeout: 30, retries: 3)
          @timeout = timeout
          @retries = retries
        end
      RUBY

      result = Rfmt.format(source)

      expect(result).to include('def configure(timeout: 30, retries: 3)')
      expect(result).not_to match(/timeout:\s+30\s+retries:/)
      expect(result).to include('@timeout = timeout')
    end
  end

  describe '.version_info' do
    it 'returns version information' do
      version = Rfmt.version_info

      expect(version).to be_a(String)
      expect(version).to include('Ruby:')
      expect(version).to include('Rust:')
    end
  end
end
