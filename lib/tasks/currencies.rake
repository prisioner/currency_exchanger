namespace :currencies do
  desc "Update currencies from OpenExchangeRates"
  task update: :environment do
    CurrencyUpdater.call
  end
end
