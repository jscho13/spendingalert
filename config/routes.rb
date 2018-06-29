Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :subscriptions
  root to: 'welcome#index'

  # Welcome Routes
  get 'sample_elements', to: 'welcome#sample_elements'
  get 'faq', to: 'welcome#faq'

  # Subscription Routes
  get 'accounts', to: 'subscriptions#accounts', as: 'accounts'
  get 'budget', to: 'subscriptions#budget', as: 'budget'
  get 'dashboard', to: 'subscriptions#dashboard', as: 'dashboard'
  get 'payment', to: 'subscriptions#payment'
  post 'charge', to: 'subscriptions#charge'
end
