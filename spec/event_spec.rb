require 'spec_helper'

shared_examples 'event' do
  it 'has @data attribute' do
    expect(@event.data).to be_a(Hash)
  end

  it 'has time attribute' do
    expect(@event.time).to be_a(DateTime)
  end

  it 'has code attribute' do
    expect(@event.code).to be_a(Symbol)
  end

  it 'has name attribute' do
    expect(@event.name).to be_a(String)
  end

  it 'has office attribute' do
    expect(@event.office).to be_a(String)
  end

  it 'has final? attribute' do
    expect(@event).to respond_to(:final?)
  end
end

describe PocztaPolska::Event do

  before :all do
    @tr = PocztaPolska::tracker
  end

  context 'without details' do
    before :all do
      pkg = @tr.check('testp0')
      @event = pkg.events[0]
    end

    it_behaves_like 'event'

    describe '#office_details' do
      it 'returns nil' do
        expect(@event.office_details).to be_nil
      end
    end
  end


  context 'with details' do
    before :all do
      pkg = @tr.check('testp0', true)
      @event = pkg.events[0]
    end

    it_behaves_like 'event'

    describe '#office_details' do
      it 'returns an Office object' do
        expect(@event.office_details).to be_instance_of(PocztaPolska::Office)
      end
    end
  end
end
