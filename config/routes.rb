Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  get 'sample_elements', to: 'welcome#sample_elements'
  get 'faq', to: 'welcome#faq'

  get 'budgeting', to: 'subscriptions#budgeting', as: :budgeting
  get 'payment', to: 'subscriptions#payment'
  post 'charge', to: 'subscriptions#charge'

  # Change later, this is for mx
  get 'new', to: 'subscriptions#new'
  get 'mx_create_user', to: 'users#mx_create_user'
  get 'mx_list_users', to: 'users#mx_list_users'
  get 'mx_connect_widget', to: 'users#mx_connect_widget'

  resources :users
  resources :subscriptions
end
