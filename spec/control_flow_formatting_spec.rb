# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rfmt, 'Control Flow Formatting' do
  describe 'break statement' do
    it 'formats simple break' do
      source = "loop do\nbreak\nend"
      result = Rfmt.format(source)
      expect(result).to include('break')
    end

    it 'formats break with value' do
      source = "loop do\nbreak 42\nend"
      result = Rfmt.format(source)
      expect(result).to include('break 42')
    end
  end

  describe 'next statement' do
    it 'formats simple next' do
      source = "[1,2,3].each do |x|\nnext if x.even?\nputs x\nend"
      result = Rfmt.format(source)
      expect(result).to include('next if x.even?')
    end

    it 'formats next with value' do
      source = "[1,2,3].map do |x|\nnext 0 if x.nil?\nx * 2\nend"
      result = Rfmt.format(source)
      expect(result).to include('next 0 if x.nil?')
    end
  end

  describe 'redo statement' do
    it 'formats redo' do
      source = "loop do\nredo if retry_needed?\nend"
      result = Rfmt.format(source)
      expect(result).to include('redo')
    end
  end

  describe 'retry statement' do
    it 'formats retry in rescue' do
      source = "begin\nconnect\nrescue\nretry\nend"
      result = Rfmt.format(source)
      expect(result).to include('retry')
    end
  end

  describe 'yield statement' do
    it 'formats simple yield' do
      source = "def with_block\nyield\nend"
      result = Rfmt.format(source)
      expect(result).to include('yield')
    end

    it 'formats yield with arguments' do
      source = "def with_block(x)\nyield x, x * 2\nend"
      result = Rfmt.format(source)
      expect(result).to include('yield x, x * 2')
    end
  end

  describe 'super statement' do
    it 'formats simple super' do
      source = "def process\nsuper\nend"
      result = Rfmt.format(source)
      expect(result).to include('super')
    end

    it 'formats super with arguments' do
      source = "def initialize(name)\nsuper(name)\nend"
      result = Rfmt.format(source)
      expect(result).to include('super(name)')
    end

    it 'formats super with block' do
      source = "def with_block\nsuper do |x|\nx * 2\nend\nend"
      result = Rfmt.format(source)
      expect(result).to include('super')
    end
  end
end
