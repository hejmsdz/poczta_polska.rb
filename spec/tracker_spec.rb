require 'spec_helper'

###########################################
#                                         #
#  MAKE SURE TO PUT YOUR API CREDENTIALS  #
#  (IF YOU HAVE THEM) IN THE ENVIRONMENT  #
#  VARIABLES POCZTA_USER AND POCZTA_PASS  #
#  BEFORE RUNNING THESE TESTS. OTHERWISE  #
#  ALL THE BUSINESS API TESTS WILL FAIL!  #
#                                         #
###########################################

shared_examples 'tracker' do

  it 'returns the API version' do
    ver = @tr.api_version
    expect(ver).to be_a(String)
  end

  it 'returns maximum number of packages' do
    max_pkgs = @tr.max_packages
    expect(max_pkgs).to be_a(Fixnum)
  end

  it 'raises an exception for unknown package' do
    expect do
      @tr.check('testp-1')
    end.to raise_exception(PocztaPolska::UnknownPackageError)
  end

  it 'raises an exception for wrong package ID' do
    expect do
      @tr.check('testp-2')
    end.to raise_exception(PocztaPolska::WrongPackageError)
  end

  it 'raises an exception on other error' do
    expect do
      @tr.check('testp-99')
    end.to raise_exception(PocztaPolska::Error)
  end

  it 'returns a Package object for a single package' do
    pkg = @tr.check('testp0')
    expect(pkg).to be_instance_of(PocztaPolska::Package)
  end
end

describe PocztaPolska::Tracker do
  context 'unregistered' do
    before :all do
     @tr = PocztaPolska::tracker
    end

    it_behaves_like 'tracker'
  end

  context 'registered' do
    before :all do
      @tr = business_tracker
    end

    it_behaves_like 'tracker'

    it 'raises an exception for too many packages' do
      expect do
        pkg = @tr.check_many(['testk-1'])
      end.to raise_exception(PocztaPolska::TooManyPackagesError)
    end

    it 'raises an exception when checking many is forbidden' do
      expect do
        pkg = @tr.check_many(['testk-2'])
      end.to raise_exception(PocztaPolska::ManyPackagesForbiddenError)
    end

    describe '#check_many' do
      before :all do
        @pkgs = @tr.check_many(['testp0', 'testp0', 'testp0'])
      end

      it 'returns an array' do
        expect(@pkgs).to be_a(Array)
      end

      it 'returns correct number of elements' do
        expect(@pkgs.length).to eql(3)
      end

      it 'returns an array of Packages' do
        expect(@pkgs).to all(be_instance_of(PocztaPolska::Package))
      end
    end
  end

end
