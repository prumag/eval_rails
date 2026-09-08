Rails.application.routes.draw do
  root "prompts#index"

  resources :prompts, only: [ :index, :new, :create, :show ]
  resources :evaluations, only: [ :create ]

  get "dashboard", to: "dashboard#index"

  namespace :api do
    resources :evaluations, only: [ :index ]
  end
end
