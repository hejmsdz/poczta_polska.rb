require 'poczta_polska/dynamic_reader'
require 'poczta_polska/office'
require 'poczta_polska/event'

module PocztaPolska
  class Package
    attr_reader :data

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

    def office_from_details
      office = @data[:dane_przesylki][:urzad_nadania][:dane_szczegolowe]
      Office.new(office) unless office.nil?
    end

    def office_to_details
      office = @data[:dane_przesylki][:urzad_przezn][:dane_szczegolowe]
      Office.new(office) unless office.nil?
    end

    def events
      @data[:dane_przesylki][:zdarzenia][:zdarzenie].map { |e| Event.new(e) }
    end
  end
end
