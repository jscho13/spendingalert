Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users
#  resources :subscriptions
  root 'welcome#index'

  # Welcome Routes
  get 'faq', to: 'welcome#faq'
  get 'terms_and_conditions', to: 'welcome#terms_and_conditions'
  get 'privacy_policy', to: 'welcome#privacy_policy'
  get '/send_messages', to: 'welcome#send_messages'
  get '/send_messages2', to: 'welcome#send_messages2'

  # Subscription Views
  get 'accounts', to: 'subscriptions#accounts', as: 'accounts'
  get 'budget', to: 'subscriptions#budget', as: 'budget'
  get 'dashboard', to: 'subscriptions#dashboard', as: 'dashboard'
  get 'transactions', to: 'subscriptions#transactions'
  get 'checkout', to: 'subscriptions#checkout'
  get 'settings', to: 'subscriptions#settings', as: 'settings'

  # Subscription Action Routes
  delete 'delete_mx_member', to: 'subscriptions#delete_mx_member'
  post 'charge', to: 'subscriptions#charge'
  get 'send_message/:id', to: 'subscriptions#send_message', as: 'send_message'

  # Press Routes
  get 'blog', to: 'press#blog'
  namespace :press do
    get 'best_online_savings'
    get 'money_saving_tips'
    get 'top_5_reasons'
  end

end
