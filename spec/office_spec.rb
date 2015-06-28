require 'spec_helper'

shared_examples 'hours' do
  it 'returns correct values' do
    # ugly as hell, but I don't know a better way to write it
    if @h.nil?
      expect(@h).to be_nil
    else
      expect(@h).to be_a(Array)
      expect(@h.length).to eql(2)
      expect(@h).to all(be_a(String))
    end
  end
end

describe PocztaPolska::Office do
  before :all do
    tr = PocztaPolska::tracker
    pkg = tr.check('testp0', true)
    @office = pkg.office_from_details
  end

  it 'has @data attribute' do
    expect(@office.data).to be_a(Hash)
  end

  describe '#coordinates' do
    before :all do
      @coords = @office.coordinates
    end

    it 'returns an Array' do
      expect(@coords).to be_a(Array)
    end

    it 'has two values' do
      expect(@coords.length).to eql(2)
    end

    it 'returns two Floats' do
      expect(@coords).to all(be_a(Float))
    end
  end

  describe '#address' do
    before :all do
      @addr = @office.address
    end

    it 'returns a Hash' do
      expect(@addr).to be_a(Hash)
    end

    it 'has the :street key' do
      expect(@addr[:street]).to be_a(String)
    end

    it 'has the :number key' do
      expect(@addr[:number]).to be_a(String)
    end

    it 'has the :code key' do
      expect(@addr[:code]).to be_a(String)
    end

    it 'has the :town key' do
      expect(@addr[:town]).to be_a(String)
    end
  end

  describe '#opening_hours' do
    before :all do
      @hours = @office.opening_hours
    end

    describe ':weekdays' do
      before :all do
        @h = @hours[:weekdays]
      end

      it_behaves_like 'hours'
    end

    describe ':saturdays' do
      before :all do
        @h = @hours[:saturdays]
      end

      it_behaves_like 'hours'
    end

    describe ':sundays' do
      before :all do
        @h = @hours[:weekdays]
      end

      it_behaves_like 'hours'
    end
  end

end
