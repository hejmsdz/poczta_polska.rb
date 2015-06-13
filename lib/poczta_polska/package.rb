require 'poczta_polska/dynamic_reader'
require 'poczta_polska/office'
require 'poczta_polska/event'

module PocztaPolska
  # The Package class contains all necessary information
  # about a tracked package.
  class Package
    # @return [Hash] Original data from the XML response
    attr_reader :data

    # Dynamic methods map
    # @see DynamicReader
    ATTR_MAP = {
      id: [:numer, :to_s],
      type: [:dane_przesylki, :kod_rodz_przes, :to_sym],
      type_str: [:dane_przesylki, :rodz_przes, :to_s],
      country_from: [:dane_przesylki, :kod_kraju_nadania, :to_sym],
      country_from_str: [:dane_przesylki, :kraj_nadania, :to_s],
      country_to: [:dane_przesylki, :kod_kraju_przezn, :to_sym],
      country_to_str: [:dane_przesylki, :kraj_przezn, :to_s],
      office_from: [:dane_przesylki, :urzad_nadania, :nazwa, :to_s],
      office_to: [:dane_przesylki, :urzad_przezn, :nazwa, :to_s],
      mass: [:dane_przesylki, :masa, nil],
      ready?: [:dane_przesylki, :zakonczono_obsluge, nil]
    }
    
    include DynamicReader

    def initialize(data)
      @data = data
    end

    # Returns detailed information about the origin post office,
    # only if the {Tracker#check}/{Tracker#check_many} method was called
    # with +details+ set to +true+.
    # @return [Office]
    def office_from_details
      office = @data[:dane_przesylki][:urzad_nadania][:dane_szczegolowe]
      Office.new(office) unless office.nil?
    end

    # Returns detailed information about the destination post office,
    # only if the {Tracker#check}/{Tracker#check_many} method was called
    # with +details+ set to +true+.
    # @return [Office]
    def office_to_details
      office = @data[:dane_przesylki][:urzad_przezn][:dane_szczegolowe]
      Office.new(office) unless office.nil?
    end

    # Returns a list of all events connected with the package
    # @return [Array<Event>]
    def events
      @data[:dane_przesylki][:zdarzenia][:zdarzenie].map { |e| Event.new(e) }
    end
  end
end
