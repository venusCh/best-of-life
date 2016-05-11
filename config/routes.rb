Rails.application.routes.draw do

  get 'profiles/:id' => 'profiles#show'
  
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks", registrations: 'registrations'}
  resources :givings do
    member do
      get :regive
    end
    resources :asks
    resources :transfers
  end
  resources :asks
  resources :transfers
  
  resources :conversations do
    member do
      post :reply
      post :index
      post :show
      post :destroy
    end
  end

  resources :messages, only: [:new, :create]

  get 'givings/index'
  get 'givings/new'
  get 'givings/show'

  root 'givings#index'

end
