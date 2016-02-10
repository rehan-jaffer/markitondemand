require 'net/http'
require "markitondemand/version"

module Markitondemand

  def self.base_url
    base_url = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?"
  end

  class Company

    attr_reader :symbol, :name, :exchange
 
    def initialize(symbol)
      @symbol = symbol.to_sym
      url = Markitondemand.base_url + "input=#{symbol}"
      begin
        result = JSON.parse(Net::HTTP.get(URI.parse(url))).keep_if { |res| res["Symbol"] == symbol }.first
        @name = result["Name"]
        @exchange = result["Exchange"]
      rescue Exception
        @success = false
      else
        @success = true
      end
    end

    def success?
      @success
    end

  end

end
