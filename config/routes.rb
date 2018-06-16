Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  get 'sample_elements', to: 'welcome#sample_elements'
  get 'faq', to: 'welcome#faq'
  get 'dashboard', to: 'subscriptions#dashboard', as: :dashboard
  get 'new', to: 'subscriptions#new'
  get 'stripe', to: 'subscriptions#stripe'

  # Change later, this is for mx
  get 'mx_create_user', to: 'users#mx_create_user'
  get 'mx_list_users', to: 'users#mx_list_users'
  get 'mx_connect_widget', to: 'users#mx_connect_widget'

  resources :users
  resources :subscriptions
end
