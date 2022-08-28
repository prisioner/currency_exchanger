require "rails_helper"

RSpec.describe CurrencyUpdater do
  describe ".call" do
    subject { described_class.call }
    let!(:currency) { Currency.create(iso: "RUB", name: "Russian ruble", rate: 30) }

    it "creates new currecies in database" do
      VCR.use_cassette("openexchangerates") do
        expect { subject }.to change(Currency, :count).from(1).to(168)
      end
    end

    it "updates existing currencies in database" do
      VCR.use_cassette("openexchangerates") do
        expect { subject }.to change { currency.reload.rate }.from(30).to(BigDecimal("60.299997"))
      end
    end
  end
end
