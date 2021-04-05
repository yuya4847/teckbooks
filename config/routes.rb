Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }
  root 'homes#home'
  resources :userpages,     only: [:show]
end
