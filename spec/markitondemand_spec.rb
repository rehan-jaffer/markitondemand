require 'spec_helper'

describe Markitondemand do
  describe "company lookup API" do
    context "successful lookup request" do
      before(:each) do
        response = [{ "Symbol" => "AAPL", "Name" => "Apple Inc", "Exchange" => "NASDAQ" }].to_json
        url = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=AAPL"
        stub_request(:any, url).to_return(body: response)
      end
      let(:company) { Markitondemand::Company.new "AAPL" }

      it "returns a successful status" do
        expect(company.success?).to eq true
      end

      it "returns the company's stock symbol" do
        expect(company.symbol).to eq :AAPL
      end

      it "returns the company's name" do
        expect(company.name).to eq "Apple Inc"
      end

      it "returns the corresponding exchange" do
        expect(company.exchange).to eq "NASDAQ"
      end
    end

    context "unsuccessful lookup request (500 error)" do
      before(:each) do
        stub_request(:any, "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=AAPL").to_return(status: 500)
      end
      let(:company) { Markitondemand::Company.new "AAPL" }

      it "sets the success field to false" do
        expect(company.success?).to eq false
      end

      it "sets a correct error message" do
        expect(company.error).to eq "API error"
      end
    end

    context "unsuccessful lookup request (no results)" do
      before(:each) do
        response = [].to_json
        url = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=AAPL"
        stub_request(:any, url).to_return(body: response)
      end
      let(:company) { Markitondemand::Company.new "AAPL" }

      it "sets the success field to false" do
        expect(company.success?).to eq false
      end

      it "sets a correct error message" do
        expect(company.error).to eq "No results"
      end
    end
  end

  describe "stock quote API" do
    let(:stock) do
      {
        "Name" => "Apple Inc",
        "Symbol" => "AAPL",
        "LastPrice" => 524.49,
        "Change" => 15.6,
        "ChangePercent" => 3.06549549018453,
        "Timestamp" => "Wed Oct 23 13:39:19 UTC-06:00 2013",
        "MSDate" => 41570.568969907,
        "MarketCap" => 476497591530,
        "Volume" => 397562,
        "ChangeYTD" => 532.1729,
        "ChangePercentYTD" => -1.44368493773359,
        "High" => 52499,
        "Low" => 519.175,
        "Open" => 519.175
      }.to_json
    end
    let(:stock_quote) { Markitondemand::StockQuote.new "AAPL" }

    context "retrieving a single quote successfully" do
      before(:each) do
        url = "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol=AAPL"
        stub_request(:any, url).to_return(body: stock)
      end

      it "sets the success field to true" do
        expect(stock_quote.success?).to eq true
      end

      it "returns the stock symbol as a symbol" do
        expect(stock_quote.symbol).to eq :AAPL
      end

      it "returns the last price" do
        expect(stock_quote.last_price).to eq 524.49
      end

      it "returns the market cap" do
        expect(stock_quote.market_cap).to eq 476497591530
      end

      it "returns the volume" do
        expect(stock_quote.volume).to eq 397562
      end

      it "returns the change YTD" do
        expect(stock_quote.change_ytd).to eq 532.1729
      end

      it "returns the change percent YTD" do
        expect(stock_quote.change_percent_ytd).to eq -1.44368493773359
      end

      it "returns the change" do
        expect(stock_quote.change).to eq 15.6
      end

      it "returns the change percentage" do
        expect(stock_quote.change_percent).to eq 3.06549549018453
      end

      #        it "returns the timestamp" do
      #          expect(stock_quote.timestamp).to eq Time.strftime("Wed Oct 23 13:39:19 UTC-06:00 2013")
      #        end

      it "returns the MSDate" do
        expect(stock_quote.msdate).to eq 41570.568969907
      end

      it "returns the last price as a float" do
        expect(stock_quote.last_price).to be_a_kind_of Float
      end

      it "returns the change as a float" do
        expect(stock_quote.change).to be_a_kind_of Float
      end

      it "returns the change percentage as a float" do
        expect(stock_quote.change_percent).to be_a_kind_of Float
      end

      it "returns the change as a float" do
        expect(stock_quote.change).to be_a_kind_of Float
      end
    end
  end
end
