Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }
  root 'homes#home'
  resources :userpages,     only: [:show]
  delete 'userpages/:id', to: 'userpages#avatar_destroy'
  get 'userpages/:id/following', to: 'userpages#following', as: 'following_user'
  get 'userpages/:id/followers', to: 'userpages#followers', as: 'followers_user'
  resources :reviews
  delete 'reviews/:id/:original_page', to: 'reviews#review_destroy', as: 'review_destroy'
  resources :relationships,       only: [:create, :destroy]
end
