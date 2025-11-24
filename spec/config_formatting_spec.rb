# frozen_string_literal: true

require 'spec_helper'
require 'rfmt'
require 'tmpdir'
require 'fileutils'

RSpec.describe 'Config-based formatting' do
  let(:source_code) do
    <<~RUBY
      class User
      def initialize(name)
      @name=name
      end
      end
    RUBY
  end

  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        example.run
      end
    end
  end

  describe 'formatting with custom indent_width' do
    it 'uses indent_width from rfmt.yml' do
      config_content = <<~YAML
        version: "1.0"
        formatting:
          line_length: 100
          indent_width: 4
          indent_style: "spaces"
      YAML
      File.write('rfmt.yml', config_content)

      formatted = Rfmt.format(source_code)

      # 4 spaces indentation should be used
      expect(formatted).to include('    def initialize(name)')
      expect(formatted).to include('        @name')
    end

    it 'uses indent_width from .rfmt.yml (backward compatibility)' do
      config_content = <<~YAML
        version: "1.0"
        formatting:
          line_length: 100
          indent_width: 4
          indent_style: "spaces"
      YAML
      File.write('.rfmt.yml', config_content)

      formatted = Rfmt.format(source_code)

      # 4 spaces indentation should be used
      expect(formatted).to include('    def initialize(name)')
      expect(formatted).to include('        @name')
    end
  end

  describe 'formatting with default config' do
    it 'uses 2 spaces when no config file exists' do
      formatted = Rfmt.format(source_code)

      # 2 spaces indentation should be used (default)
      expect(formatted).to include('  def initialize(name)')
      expect(formatted).to include('    @name')
    end
  end

  describe 'config file priority' do
    it 'prefers rfmt.yml over .rfmt.yml' do
      # Create both files with different configs
      File.write('rfmt.yml', <<~YAML)
        version: "1.0"
        formatting:
          indent_width: 3
          indent_style: "spaces"
      YAML

      File.write('.rfmt.yml', <<~YAML)
        version: "1.0"
        formatting:
          indent_width: 4
          indent_style: "spaces"
      YAML

      formatted = Rfmt.format(source_code)

      # Should use rfmt.yml (3 spaces)
      expect(formatted).to include('   def initialize(name)')
      expect(formatted).to include('      @name')
    end
  end

  describe 'config discovery in parent directories' do
    it 'finds config in parent directory' do
      # Create config in current directory
      config_content = <<~YAML
        version: "1.0"
        formatting:
          indent_width: 4
          indent_style: "spaces"
      YAML
      File.write('rfmt.yml', config_content)

      # Create subdirectory and format from there
      Dir.mkdir('subdir')
      Dir.chdir('subdir') do
        formatted = Rfmt.format(source_code)

        # Should still use parent's config (4 spaces)
        expect(formatted).to include('    def initialize(name)')
        expect(formatted).to include('        @name')
      end
    end
  end
end
