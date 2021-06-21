Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }
  root 'homes#home'
  resources :userpages,     only: [:show]
  delete 'userpages/:id', to: 'userpages#avatar_destroy'
  resources :reviews
  delete 'reviews/:id/:original_page', to: 'reviews#review_destroy', as: 'review_destroy'
end
