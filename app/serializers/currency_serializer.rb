class CurrencySerializer < ActiveModel::Serializer
  attributes :iso, :name, :rate
end
