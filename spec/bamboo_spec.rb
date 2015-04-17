require 'spec_helper'
require 'bamboo'

describe Bamboo do
  it 'has a version number' do
    expect(Bamboo::VERSION).not_to be nil
  end

  it 'instantiates client' do
    expect(Bamboo::Client).to receive(:new).with('somehost')
    described_class.new('somehost')
  end
end
