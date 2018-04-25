Rails.application.routes.draw do
  mount Payola::Engine => '/payola', as: :payola
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#landing"
end
