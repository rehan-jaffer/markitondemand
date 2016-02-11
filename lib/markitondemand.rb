require 'net/http'
require "markitondemand/version"

module Markitondemand
  def self.base_url
    "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?"
  end

  class NoResultException < Exception
  end

  class ResultsArray
    attr_reader :results

    def initialize(results)
      @results = results
    end

    def single_company(symbol)
      @results.keep_if { |res| res["Symbol"] == symbol }.first
    end
  end

  class Error
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end

  class Company
    attr_reader :symbol, :name, :exchange, :error

    def initialize(symbol)
      @symbol = symbol.to_sym
      url = Markitondemand.base_url + "input=#{symbol}"
      result = get_result(url)
      if result.is_a?(Error)
        @error = result.message
        @success = false
        return
      end
      result = ResultsArray.new(result).single_company(symbol)
      @name = result["Name"]
      @exchange = result["Exchange"]
      @success = true
    end

    def get_result(url)
      begin
        result = JSON.parse(Net::HTTP.get(URI.parse(url)))
      rescue TypeError
        return Error.new("API error")
      end
      if result.length == 0
        return Error.new("No results")
      end
      result
    end

    def success?
      @success
    end
  end
end
