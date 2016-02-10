require 'spec_helper'

describe Markitondemand do

  describe "company lookup API" do

    context "successful lookup request" do
     before(:each) do
       stub_request(:any, "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=AAPL").to_return(body: [{"Symbol"=>"AAPL", "Name"=>"Apple Inc", "Exchange"=>"NASDAQ"}].to_json)
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

   context "unsuccessful lookup request" do
     let(:company) { Markitondemand::Company.new "AAPL" }
   end

  end

  describe "stock quote API" do
  end

end
