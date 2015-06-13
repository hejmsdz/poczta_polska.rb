require "poczta_polska/version"

module PocztaPolska

  Error = Class.new(RuntimeError)
  UnknownPackageError = Class.new(Error)
  WrongPackageError = Class.new(Error)
  TooManyPackagesError = Class.new(Error)
  ManyPackagesForbiddenError = Class.new(Error)
  DateRangeError = Class.new(Error)

  def self.tracker(username = nil, password = nil)
    if username.nil? && password.nil?
      Tracker.new('https://tt.poczta-polska.pl/Sledzenie/services/Sledzenie?wsdl', 'sledzeniepp', 'PPSA')
    else
      Tracker.new('https://ws.poczta-polska.pl/Sledzenie/services/Sledzenie?wsdl', username, password)
    end
  end

  require "poczta_polska/tracker"
  require "poczta_polska/package"
  require "poczta_polska/office"
  require "poczta_polska/event"
end
