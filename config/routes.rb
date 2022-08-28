Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :currencies, param: :iso_code, only: %i[index show]
    end
  end
end
