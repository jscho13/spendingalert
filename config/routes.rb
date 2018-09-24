Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :subscriptions
  root to: 'welcome#index'

  # Welcome Routes
  get 'faq', to: 'welcome#faq'
  get 'terms_and_conditions', to: 'welcome#terms_and_conditions'
  get 'privacy_policy', to: 'welcome#privacy_policy'

  # Subscription Routes
  get 'accounts', to: 'subscriptions#accounts', as: 'accounts'
  get 'budget', to: 'subscriptions#budget', as: 'budget'
  get 'dashboard', to: 'subscriptions#dashboard', as: 'dashboard'
  get 'payment', to: 'subscriptions#payment'
  get 'transactions', to: 'subscriptions#transactions'
  delete 'delete_mx_member', to: 'subscriptions#delete_mx_member'
  get 'checkout', to: 'subscriptions#checkout'

  # Action Routes
  post 'charge', to: 'subscriptions#charge'
  get 'send_message', to: 'subscriptions#send_message', as: 'send_message'
  get 'send_messages', to: 'subscriptions#send_messages', as: 'send_messages'

  # Press Routes
  get 'blog', to: 'press#blog'
  namespace :press do
    get 'best_online_savings'
    get 'money_saving_tips'
    get 'top_5_reasons'
  end

end
