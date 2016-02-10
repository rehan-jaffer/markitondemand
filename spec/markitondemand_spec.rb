require 'spec_helper'

describe Markitondemand do

  describe "company lookup API" do

    context "successful lookup request" do
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

  end

  describe "stock quote API" do

  end

end
