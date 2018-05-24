Rails.application.routes.draw do
  mount Payola::Engine => '/payola', as: :payola
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  get 'dashboard', to: 'welcome#dashboard'
  resources :users

	resources :subscriptions

  get 'sample_index', to: 'welcome#sample_index'
  get 'sample_generic', to: 'welcome#sample_generic'
  get 'sample_elements', to: 'welcome#sample_elements'
end
