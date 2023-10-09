Rails.application.routes.draw do
  root "entities#index"
  resources :entities do
    resources :loans
  end
end
