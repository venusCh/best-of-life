Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks", registrations: 'registrations'}
  resources :givings do
    resources :asks
    resources :transfers
  end
  resources :asks
  resources :transfers
  
  resources :conversations, only: [:index, :show, :destroy]
  resources :messages, only: [:new, :create]

  get 'givings/index'
  get 'givings/new'
  get 'givings/show'

  root 'givings#index'

end
