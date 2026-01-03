# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rfmt, 'Ensure Formatting' do
  describe 'basic ensure' do
    it 'formats begin-ensure block' do
      source = "begin\ndo_something\nensure\ncleanup\nend"
      result = Rfmt.format(source)
      expect(result).to include('ensure')
      expect(result).to include('cleanup')
    end
  end

  describe 'begin-rescue-ensure' do
    it 'formats complete exception handling' do
      source = "begin\nrisky\nrescue StandardError => e\nhandle(e)\nensure\ncleanup\nend"
      result = Rfmt.format(source)
      expect(result).to include('rescue StandardError => e')
      expect(result).to include('ensure')
      expect(result).to include('cleanup')
    end
  end

  describe 'method with ensure' do
    it 'formats def with implicit begin-ensure' do
      source = "def process\nacquire_lock\nensure\nrelease_lock\nend"
      result = Rfmt.format(source)
      expect(result).to include('def process')
      expect(result).to include('ensure')
      expect(result).to include('release_lock')
    end
  end

  describe 'ensure with multiple statements' do
    it 'formats ensure with multiple cleanup statements' do
      source = "def cleanup_resources\nuse_resource\nensure\nclose_file\nrelease_memory\nend"
      result = Rfmt.format(source)
      expect(result).to include('ensure')
      expect(result).to include('close_file')
      expect(result).to include('release_memory')
    end
  end
end
