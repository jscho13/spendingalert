Rails.application.routes.draw do
  mount Payola::Engine => '/payola', as: :payola
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  get 'sample_elements', to: 'welcome#sample_elements'
  get 'faq', to: 'welcome#faq'
  get 'dashboard', to: 'subscriptions#dashboard', as: :dashboard
  get 'new', to: 'subscriptions#new'

  resources :users
  resources :subscriptions
end
