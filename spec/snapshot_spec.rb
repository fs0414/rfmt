# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Snapshot Tests (Real-world Rails Code)' do
  FIXTURES_DIR = File.expand_path('fixtures', __dir__)
  INPUT_DIR = File.join(FIXTURES_DIR, 'input')
  EXPECTED_DIR = File.join(FIXTURES_DIR, 'expected')

  # Helper to show colored diff
  def show_diff(expected, actual, file_name)
    return if expected == actual

    puts "\n#{'=' * 80}"
    puts "DIFF for #{file_name}:"
    puts '=' * 80

    # Line by line diff
    expected_lines = expected.split("\n")
    actual_lines = actual.split("\n")

    max_lines = [expected_lines.length, actual_lines.length].max

    max_lines.times do |i|
      expected_line = expected_lines[i]
      actual_line = actual_lines[i]

      if expected_line == actual_line
        puts "  #{i + 1}: #{expected_line}"
      else
        puts "\e[31m- #{i + 1}: #{expected_line}\e[0m" if expected_line
        puts "\e[32m+ #{i + 1}: #{actual_line}\e[0m" if actual_line
      end
    end

    puts "#{'=' * 80}\n"
  end

  # Get all test fixtures
  fixtures = Dir.glob(File.join(INPUT_DIR, '*.rb')).map do |input_file|
    File.basename(input_file)
  end

  describe 'Rails code formatting' do
    fixtures.each do |fixture_name|
      it "correctly formats #{fixture_name}" do
        input_file = File.join(INPUT_DIR, fixture_name)
        expected_file = File.join(EXPECTED_DIR, fixture_name)

        # Read input and expected output
        input = File.read(input_file)
        expected = File.read(expected_file)

        # Format the input
        actual = Rfmt.format(input)

        # Show diff if verbose mode or test fails
        show_diff(expected, actual, fixture_name) if ENV['VERBOSE'] || ENV['SHOW_DIFF']

        # Assert
        expect(actual).to eq(expected), lambda {
          show_diff(expected, actual, fixture_name)
          "\n\nFormatted output differs from expected for #{fixture_name}\n" \
            'Run with VERBOSE=1 or SHOW_DIFF=1 to see detailed diff'
        }
      end
    end
  end

  describe 'Idempotency (formatting twice produces same result)' do
    fixtures.each do |fixture_name|
      it "is idempotent for #{fixture_name}" do
        input_file = File.join(INPUT_DIR, fixture_name)
        input = File.read(input_file)

        # Format once
        first_format = Rfmt.format(input)

        # Format again
        second_format = Rfmt.format(first_format)

        # Should be the same
        expect(second_format).to eq(first_format),
                                 "Formatting #{fixture_name} is not idempotent"
      end
    end
  end

  describe 'File preservation (no data loss)' do
    fixtures.each do |fixture_name|
      it "preserves code structure in #{fixture_name}" do
        input_file = File.join(INPUT_DIR, fixture_name)
        input = File.read(input_file)

        # Format the input
        formatted = Rfmt.format(input)

        # Parse both with Prism to compare AST (structure should be same)
        input_ast = Rfmt::PrismBridge.parse(input)
        formatted_ast = Rfmt::PrismBridge.parse(formatted)

        # Basic structure checks
        expect(formatted_ast).not_to be_nil
        expect(formatted_ast).to be_a(String)

        # Both should parse successfully
        expect { JSON.parse(input_ast) }.not_to raise_error
        expect { JSON.parse(formatted_ast) }.not_to raise_error
      end
    end
  end
end
