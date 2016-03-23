Rails.application.routes.draw do

  devise_for :users
  resources :givings do
    resources :asks
  end
  resources :asks
  
  resources :conversations, only: [:index, :show, :destroy]
  resources :messages, only: [:new, :create]

  get 'givings/index'
  get 'givings/new'
  get 'givings/show'

  root 'givings#index'

end
