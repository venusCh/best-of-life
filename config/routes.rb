Rails.application.routes.draw do

  devise_for :users
  resources :givings

  get 'givings/index'
  get 'givings/new'
  get 'givings/show'

  root 'givings#index'

end
