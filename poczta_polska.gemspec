# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poczta_polska/version'

Gem::Specification.new do |spec|
  spec.name          = "poczta_polska"
  spec.version       = PocztaPolska::VERSION
  spec.authors       = ["Mikołaj Rozwadowski"]
  spec.email         = ["mikolaj.rozwadowski@outlook.com"]

  spec.summary       = "Track Polish Post packages in Ruby"
  spec.description   = "With this gem you can monitor Polish Post parcels and registered mail "
                       "as well as packages shipped by Pocztex. It allows you to see basic data "
                       "about the consignment as well as all the post offices it has gone through "
                       "(including their locations and opening hours). The data is downloaded from "
                       "[a public SOAP API of the Polish Post](http://www.poczta-polska.pl/pliki/webservices/"
                       "Metody%20i%20struktury%20uslugi%20sieciowej%20Poczty%20Polskiej%20SA.pdf) "
                       "and wrapped into Ruby classes for your convenience."
  spec.homepage      = "https://github.com/hejmsdz/poczta_polska.rb"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.11.1"
  spec.add_dependency "rubyntlm", "~> 0.5.0"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "yard"
end
