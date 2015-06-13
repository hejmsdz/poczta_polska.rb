require 'savon'

module PocztaPolska
  class Tracker
    def initialize(wsdl, username, password)
      @client = Savon.client(wsdl: wsdl, wsse_auth: [username, password])
    end

    def api_version
      resp = @client.call(:wersja)
      resp.body[:wersja_response][:return].to_s
    end

    def max_packages
      resp = @client.call(:maksymalna_liczba_przesylek)
      resp.body[:maksymalna_liczba_przesylek_response][:return].to_i
    end

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
