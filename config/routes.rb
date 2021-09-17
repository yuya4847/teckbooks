Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }
  root 'homes#home'
  resources :userpages,     only: [:show]
  delete 'userpages/:id', to: 'userpages#avatar_destroy'
  get 'userpages/:id/following', to: 'userpages#following', as: 'following_user'
  get 'userpages/:id/followers', to: 'userpages#followers', as: 'followers_user'
  resources :reviews do
    resources :comments, only: [:create, :destroy]
  end
  get 'all_reviews', to: 'reviews#all_reviews', as: 'all_reviews'
  post 'tag_search_review/:id', to: 'reviews#tag_search', as: 'tag_search_reviews'

  post 'comments/:review_id/:parent_id/response_comments', to: 'comments#response_create', as: 'response_comments'
  delete 'comments/response_comments/:id', to: 'comments#response_destroy', as: 'response_comment'
  post 'comments/cancel_response/:id', to: 'comments#cancel_response', as: 'cancel_response'
  post 'comments/cancel_comment', to: 'comments#cancel_comment', as: 'cancel_comment'

  delete 'reviews/:id/:original_page', to: 'reviews#review_destroy', as: 'review_destroy'
  resources :relationships,       only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show, :destroy]
end
