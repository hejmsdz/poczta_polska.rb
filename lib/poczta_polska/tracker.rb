require 'savon'

module PocztaPolska
  # The Tracker class gives access to all necessary API methods
  # and wraps the results in correct Ruby classes.
  class Tracker
    def initialize(wsdl, username, password)
      @client = Savon.client(wsdl: wsdl, wsse_auth: [username, password])
    end

    # Returns the API version you are using.
    def api_version
      resp = @client.call(:wersja)
      resp.body[:wersja_response][:return].to_s
    end

    # Returns the maximum number of packages that you can
    # check in a single request with {#check_many} method.
    # If you are not authenticated, it is always 1.
    def max_packages
      resp = @client.call(:maksymalna_liczba_przesylek)
      resp.body[:maksymalna_liczba_przesylek_response][:return].to_i
    end

    # Finds a package by its ID.
    # @param package_id [String] the ID of a package to find
    # @param details [Boolean] whether to include detailed information (location, opening hours) about the post offices involved
    # @return [Package] information about the package
    # @raise [UnknownPackageError] if the package couldn't be found
    # @raise [WrongPackageError] if the package ID is invalid
    # @raise [Error] if something else goes wrong
    def check(package_id, details = false)
      method_name = 'sprawdz_przesylke'
      method_name << '_pl' if details

      method = method_name.to_sym
      response_key = "#{method_name}_response".to_sym

      response = @client.call(method, message: {numer: package_id})
      data = response.body[response_key][:return]

      case data[:status].to_i
      when -1 then raise UnknownPackageError
      when -2 then raise WrongPackageError
      when -99 then raise Error
      end

      Package.new(data)
    end

    # Finds multiple packages by their IDs.
    # @param package_ids [Array<String>] IDs of the packages to find
    # @param details [Boolean] whether to include detailed information (location, opening hours) about the post offices involved
    # @param date_range [Range<Date>] narrow the list down so that it only includes packages with events in the specified date range
    # @return [Array<Package>] information about the packages found
    # @raise [TooManyPackagesError] if you exceed the limit of packages you can check in a single request ({#max_packages})
    # @raise [ManyPackagesForbiddenError] if you are not authenticated, so you can't check many packages at once
    # @raise [DateRangeError] if the date range specified is invalid
    # @raise [Error] if something else goes wrong
    def check_many(package_ids, details = false, date_range = nil)
      method_name = 'sprawdz_przesylki'
      method_name << '_od_do' unless date_range.nil?
      method_name << '_pl' if details

      method = method_name.to_sym
      response_key = "#{method_name}_response".to_sym

      params = {numery: package_ids}
      unless date_range.nil?
        params[:od_dnia] = date_range.first.iso8601
        params[:do_dnia] = date_range.end.iso8601
      end

      response = @client.call(method, message: params)
      data = response.body[response_key][:return]

      case data[:status].to_i
      when -1 then raise TooManyPackagesError
      when -2 then raise ManyPackagesForbiddenError
      when -3 then raise DateRangeError
      when -99 then raise Error
      end

      data[:przesylki].map { |p| Package.new(p) }
    end
  end
end
