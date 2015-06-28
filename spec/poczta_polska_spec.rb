require 'spec_helper'

describe PocztaPolska do
  it 'has a version number' do
    expect(PocztaPolska::VERSION).not_to be nil
  end

  it 'creates a Tracker object' do
    tr = PocztaPolska.tracker
    expect(tr).to be_instance_of(PocztaPolska::Tracker)
  end
end

