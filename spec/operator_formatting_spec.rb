# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rfmt, 'Operator Formatting' do
  describe 'logical operators' do
    it 'formats and operator' do
      source = 'x && y'
      result = Rfmt.format(source)
      expect(result.strip).to eq('x && y')
    end

    it 'formats or operator' do
      source = 'x || y'
      result = Rfmt.format(source)
      expect(result.strip).to eq('x || y')
    end

    it 'formats not operator' do
      source = '!valid?'
      result = Rfmt.format(source)
      expect(result).to include('!valid?')
    end

    it 'formats not with expression' do
      source = '!(x && y)'
      result = Rfmt.format(source)
      expect(result).to include('!(x && y)')
    end
  end

  describe 'range operators' do
    it 'formats inclusive range' do
      source = '1..10'
      result = Rfmt.format(source)
      expect(result).to include('1..10')
    end

    it 'formats exclusive range' do
      source = '1...10'
      result = Rfmt.format(source)
      expect(result).to include('1...10')
    end

    it 'formats range with variables' do
      source = 'start..finish'
      result = Rfmt.format(source)
      expect(result).to include('start..finish')
    end
  end

  describe 'splat operator' do
    it 'formats splat in method call' do
      source = 'method(*args)'
      result = Rfmt.format(source)
      expect(result).to include('*args')
    end

    it 'formats splat in array literal' do
      source = '[*items, extra]'
      result = Rfmt.format(source)
      expect(result).to include('*items')
    end
  end

  describe 'rescue modifier' do
    it 'formats inline rescue' do
      source = 'risky_operation rescue nil'
      result = Rfmt.format(source)
      expect(result).to include('risky_operation rescue nil')
    end

    it 'formats rescue with method call' do
      source = 'JSON.parse(data) rescue {}'
      result = Rfmt.format(source)
      expect(result).to include('rescue')
    end
  end

  describe 'regular expressions' do
    it 'formats simple regex' do
      source = '/pattern/'
      result = Rfmt.format(source)
      expect(result).to include('/pattern/')
    end

    it 'formats regex with flags' do
      source = '/pattern/i'
      result = Rfmt.format(source)
      expect(result).to include('/pattern/i')
    end

    it 'formats regex in match' do
      source = 'str =~ /\\d+/'
      result = Rfmt.format(source)
      expect(result).to include('=~')
    end
  end
end
