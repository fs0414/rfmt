# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rfmt, 'Lambda Formatting' do
  it 'formats stabby lambda' do
    source = '-> { 42 }'
    result = Rfmt.format(source)
    expect(result.strip).to eq('-> { 42 }')
  end

  it 'formats Rails scope with lambda' do
    source = 'scope :active, -> { where(active: true) }'
    result = Rfmt.format(source)
    expect(result).to include('-> { where(active: true) }')
  end
end
