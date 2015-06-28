require 'spec_helper'

shared_examples 'package' do
  it 'has @data attribute' do
    expect(@pkg.data).to be_a(Hash)
  end

  it 'has id attribute' do
    expect(@pkg.id).to be_a(String)
  end

  it 'has type attribute' do
    expect(@pkg.type).to be_a(Symbol)
  end

  it 'has type_str attribute' do
    expect(@pkg.type_str).to be_a(String)
  end

  it 'has country_from attribute' do
    expect(@pkg.country_from).to be_a(Symbol)
  end

  it 'has country_from_str attribute' do
    expect(@pkg.country_from_str).to be_a(String)
  end

  it 'has country_to attribute' do
    expect(@pkg.country_to).to be_a(Symbol)
  end

  it 'has country_to_str attribute' do
    expect(@pkg.country_to_str).to be_a(String)
  end

  it 'has office_from attribute' do
    expect(@pkg.office_from).to be_a(String)
  end

  it 'has office_to attribute' do
    expect(@pkg.office_to).to be_a(String)
  end

  it 'has mass attribute' do
    expect(@pkg).to respond_to(:mass)
  end

  it 'has ready? attribute' do
    expect(@pkg).to respond_to(:ready?)
  end

  describe '#events' do
    before :all do
      @events = @pkg.events
    end

    it 'returns an array' do
      expect(@events).to be_a(Array)
    end

    it 'returns an array of Events' do
      expect(@events).to all(be_instance_of(PocztaPolska::Event))
    end
  end
end

shared_examples 'has_details' do
  describe '#office_from_details' do
    it 'returns an Office object' do
      expect(@pkg.office_from_details).to be_instance_of(PocztaPolska::Office)
    end
  end

  describe '#office_to_details' do
    it 'returns an Office object' do
      expect(@pkg.office_to_details).to be_instance_of(PocztaPolska::Office)
    end
  end
end

shared_examples 'has_no_details' do
  describe '#office_from_details' do
    it 'returns nil' do
      expect(@pkg.office_from_details).to be_nil
    end
  end

  describe '#office_to_details' do
    it 'returns nil' do
      expect(@pkg.office_to_details).to be_nil
    end
  end
end

describe PocztaPolska::Package do
  context 'single' do
    before :all do
      @tr = PocztaPolska::tracker
    end

    context 'with details' do
      before :all do
        @pkg = @tr.check('testp0', true)
      end

      it_behaves_like 'package'
      it_behaves_like 'has_details'
    end

    context 'without details' do
      before :all do
        @pkg = @tr.check('testp0')
      end

      it_behaves_like 'package'
      it_behaves_like 'has_no_details'
    end
  end


  context 'multiple' do
    before :all do
      @tr = business_tracker
    end

    context 'with details' do
      before :all do
        pkgs = @tr.check_many(['testp0', 'testp0', 'testp0'], true)
        @pkg = pkgs[0]
      end

      it_behaves_like 'package'
      it_behaves_like 'has_details'
    end

    context 'without details' do
      before :all do
        pkgs = @tr.check_many(['testp0', 'testp0', 'testp0'])
        @pkg = pkgs[0]
      end

      it_behaves_like 'package'
      it_behaves_like 'has_no_details'
    end
  end


  context 'multiple, but actually checking one' do
    before :all do
      @tr = business_tracker
    end

    context 'with details' do
      before :all do
        pkgs = @tr.check_many(['testp0'], true)
        @pkg = pkgs[0]
      end

      it_behaves_like 'package'
      it_behaves_like 'has_details'
    end

    context 'without details' do
      before :all do
        pkgs = @tr.check_many(['testp0'])
        @pkg = pkgs[0]
      end

      it_behaves_like 'package'
      it_behaves_like 'has_no_details'
    end
  end
end
