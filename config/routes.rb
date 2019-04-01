Mp::Application.routes.draw do
  devise_for :users
  resources :sites
  root "sites#index"

  get "home/index", path: :currencyconverter

  localized do
    get "home/index", path: :currencyconverter
  end
end
