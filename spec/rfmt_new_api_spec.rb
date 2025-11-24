# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Rfmt New API' do
  describe '.format' do
    it 'formats simple code' do
      source = "class Foo\nend"
      result = Rfmt.format(source)
      expect(result).to eq(source) # Phase 1: 入力をそのまま返す
    end

    it 'handles empty input' do
      result = Rfmt.format('')
      expect(result).to eq('')
    end

    it 'handles multiline code' do
      source = "class Foo\n  def bar\n    42\n  end\nend"
      result = Rfmt.format(source)
      expect(result).to eq(source) # Phase 1: 入力をそのまま返す
    end
  end

  describe '.rust_version' do
    it 'returns version string' do
      version = Rfmt.rust_version
      expect(version).to eq('0.1.0 (Rust)')
    end
  end
end
