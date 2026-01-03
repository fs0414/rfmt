# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rfmt, 'Loop Formatting' do
  describe 'while loop' do
    it 'formats basic while loop' do
      source = "while x < 10\nx += 1\nend"
      result = Rfmt.format(source)
      expect(result).to include('while x < 10')
      expect(result).to include('x += 1')
      expect(result).to include('end')
    end

    it 'formats while with method call condition' do
      source = "while running?\nprocess\nend"
      result = Rfmt.format(source)
      expect(result).to include('while running?')
      expect(result).to include('process')
    end

    it 'formats postfix while' do
      source = 'x += 1 while x < 10'
      result = Rfmt.format(source)
      expect(result).to include('x += 1 while x < 10')
    end
  end

  describe 'until loop' do
    it 'formats basic until loop' do
      source = "until done\nwork\nend"
      result = Rfmt.format(source)
      expect(result).to include('until done')
      expect(result).to include('work')
      expect(result).to include('end')
    end

    it 'formats postfix until' do
      source = 'sleep 1 until ready?'
      result = Rfmt.format(source)
      expect(result).to include('sleep 1 until ready?')
    end
  end

  describe 'for loop' do
    it 'formats basic for loop' do
      source = "for i in 1..10\nputs i\nend"
      result = Rfmt.format(source)
      expect(result).to include('for i in 1..10')
      expect(result).to include('puts i')
      expect(result).to include('end')
    end

    it 'formats for with array' do
      source = "for item in items\nprocess(item)\nend"
      result = Rfmt.format(source)
      expect(result).to include('for item in items')
      expect(result).to include('process(item)')
    end
  end
end
