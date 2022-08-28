class CurrencyUpdater
  BASE_URL = "https://openexchangerates.org/api".freeze
  APP_ID = ENV.fetch("OPENEXCHANGERATES_APP_ID").freeze

  def self.call
    new.call
  end

  def call
    currencies_params = currency_codes.map do |currency_iso|
      {
        iso: currency_iso,
        name: currencies_list[currency_iso],
        rate: BigDecimal(rates_list[currency_iso], 12)
      }
    end

    ActiveRecord::Base.transaction do
      currencies_params.each do |currency_params|
        Currency
          .find_or_initialize_by(iso: currency_params[:iso])
          .update(name: currency_params[:name], rate: currency_params[:rate])
      end
    end
  end

  private

  def currencies_list
    @currencies_list ||= send_request("currencies.json")
  end

  def rates_list
    @rates_list ||= send_request("latest.json")["rates"]
  end

  def currency_codes
    @currency_codes ||= rates_list.keys - Currency::IGNORED_ISO_CODES
  end

  def send_request(endpoint)
    HTTParty
      .get("#{BASE_URL}/#{endpoint}", query: {app_id: APP_ID, show_alternative: true})
      .parsed_response
  end
end
