Rails.application.routes.draw do

  devise_for :users
  resources :givings do
    resources :asks
  end

  get 'givings/index'
  get 'givings/new'
  get 'givings/show'

  root 'givings#welcome'

end
