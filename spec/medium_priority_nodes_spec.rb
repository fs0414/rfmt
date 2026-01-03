# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rfmt, 'Medium Priority Nodes' do
  describe 'class variables' do
    it 'formats class variable read' do
      source = "def count\n@@counter\nend"
      result = Rfmt.format(source)
      expect(result).to include('@@counter')
    end

    it 'formats class variable write' do
      source = '@@counter = 0'
      result = Rfmt.format(source)
      expect(result).to include('@@counter = 0')
    end

    it 'formats class variable or-assign' do
      source = '@@cache ||= {}'
      result = Rfmt.format(source)
      expect(result).to include('@@cache ||= {}')
    end
  end

  describe 'global variables' do
    it 'formats global variable read' do
      source = 'puts $stdout'
      result = Rfmt.format(source)
      expect(result).to include('$stdout')
    end

    it 'formats global variable write' do
      source = '$DEBUG = true'
      result = Rfmt.format(source)
      expect(result).to include('$DEBUG = true')
    end

    it 'formats global variable or-assign' do
      source = '$config ||= load_config'
      result = Rfmt.format(source)
      expect(result).to include('$config ||= load_config')
    end
  end

  describe 'compound assignment' do
    it 'formats local variable or-assign' do
      source = 'name ||= "default"'
      result = Rfmt.format(source)
      expect(result).to include('name ||= "default"')
    end

    it 'formats local variable and-assign' do
      source = 'value &&= process(value)'
      result = Rfmt.format(source)
      expect(result).to include('value &&= process(value)')
    end

    it 'formats local variable operator-assign' do
      source = 'count += 1'
      result = Rfmt.format(source)
      expect(result).to include('count += 1')
    end

    it 'formats instance variable or-assign' do
      source = '@cache ||= {}'
      result = Rfmt.format(source)
      expect(result).to include('@cache ||= {}')
    end

    it 'formats constant or-assign' do
      source = 'CONFIG ||= {}'
      result = Rfmt.format(source)
      expect(result).to include('CONFIG ||= {}')
    end
  end

  describe 'interpolated literals' do
    it 'formats interpolated symbol' do
      source = ':"user_#{id}"'
      result = Rfmt.format(source)
      expect(result).to include(':"user_#{id}"')
    end

    it 'formats interpolated regex' do
      # rubocop:disable Lint/InterpolationCheck
      source = '/#{pattern}/i'
      result = Rfmt.format(source)
      expect(result).to include('/#{pattern}/i')
      # rubocop:enable Lint/InterpolationCheck
    end

    it 'formats backtick command' do
      source = '`ls -la`'
      result = Rfmt.format(source)
      expect(result).to include('`ls -la`')
    end

    it 'formats interpolated backtick command' do
      # rubocop:disable Lint/InterpolationCheck
      source = '`echo #{message}`'
      result = Rfmt.format(source)
      expect(result).to include('`echo #{message}`')
      # rubocop:enable Lint/InterpolationCheck
    end
  end

  describe 'pattern matching' do
    it 'formats case-in pattern match' do
      source = "case data\nin { name: }\nputs name\nend"
      result = Rfmt.format(source)
      expect(result).to include('case data')
      expect(result).to include('in {')
    end

    it 'formats match predicate (in operator)' do
      source = 'value in [1, 2, 3]'
      result = Rfmt.format(source)
      expect(result).to include('value in [1, 2, 3]')
    end

    it 'formats match required (=> operator)' do
      source = 'data => { name:, age: }'
      result = Rfmt.format(source)
      expect(result).to include('=>')
    end
  end

  describe 'self' do
    it 'formats self reference' do
      source = "def id\nself.object_id\nend"
      result = Rfmt.format(source)
      expect(result).to include('self.object_id')
    end
  end

  describe 'parentheses' do
    it 'formats parenthesized expression' do
      source = '(a + b) * c'
      result = Rfmt.format(source)
      expect(result).to include('(a + b) * c')
    end
  end

  describe 'defined?' do
    it 'formats defined? check' do
      source = 'defined?(Rails)'
      result = Rfmt.format(source)
      expect(result).to include('defined?(Rails)')
    end
  end

  describe 'singleton class' do
    it 'formats singleton class definition' do
      source = "class << self\ndef instance_method\nend\nend"
      result = Rfmt.format(source)
      expect(result).to include('class << self')
      expect(result).to include('end')
    end
  end

  describe 'alias' do
    it 'formats alias method' do
      source = 'alias new_method old_method'
      result = Rfmt.format(source)
      expect(result).to include('alias new_method old_method')
    end

    it 'formats alias with symbols' do
      source = 'alias :new_method :old_method'
      result = Rfmt.format(source)
      expect(result).to include('alias :new_method :old_method')
    end
  end

  describe 'undef' do
    it 'formats undef' do
      source = 'undef :method_name'
      result = Rfmt.format(source)
      expect(result).to include('undef :method_name')
    end
  end

  describe 'hash splat' do
    it 'formats hash splat in method call' do
      source = 'method(**options)'
      result = Rfmt.format(source)
      expect(result).to include('**options')
    end

    it 'formats hash splat in hash literal' do
      source = '{ **defaults, key: value }'
      result = Rfmt.format(source)
      expect(result).to include('**defaults')
    end
  end

  describe 'block argument' do
    it 'formats block argument' do
      source = 'method(&block)'
      result = Rfmt.format(source)
      expect(result).to include('&block')
    end

    it 'formats symbol to proc' do
      source = 'items.map(&:to_s)'
      result = Rfmt.format(source)
      expect(result).to include('&:to_s')
    end
  end

  describe 'multiple assignment' do
    it 'formats multiple assignment' do
      source = 'a, b, c = [1, 2, 3]'
      result = Rfmt.format(source)
      expect(result).to include('a, b, c = [1, 2, 3]')
    end

    it 'formats splat in multiple assignment' do
      source = 'first, *rest = items'
      result = Rfmt.format(source)
      expect(result).to include('first, *rest = items')
    end
  end
end
