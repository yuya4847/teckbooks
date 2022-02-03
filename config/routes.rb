Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }
  devise_scope :user do
    get '/users', to: 'users/registrations#new'
  end
  root 'homes#home'
  get 'homes/search', to: 'homes#search'
  get 'homes/terms', to: 'homes#terms', as: 'show_terms'
  get 'homes/privacy_policy', to: 'homes#privacy_policy', as: 'show_privacy_policy'
  get 'homes/suggest', to: 'homes#suggest'

  post 'review_like/create', to: 'review_like#create'
  post 'review_like/destroy', to: 'review_like#destroy'
  post 'review_follow/create', to: 'review_follow#create'
  post 'review_follow/destroy', to: 'review_follow#destroy'
  post 'userpages/review_follow/create', to: 'review_follow#create'
  post 'userpages/review_follow/destroy', to: 'review_follow#destroy'
  post 'userpages/profile_reviews/review_follow/create', to: 'review_follow#create'
  post 'userpages/profile_reviews/review_follow/destroy', to: 'review_follow#destroy'

  resources :userpages,     only: [:show]
  delete 'userpages/:id', to: 'userpages#avatar_destroy'
  get 'userpages/profile_reviews/:id', to: 'userpages#profile_reviews', as: 'profile_reviews'
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
  resources :reports, only: [:create]
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show, :destroy]
  resources :notifications, only: [:index, :destroy]
  delete 'notification_all_destory', to: 'notifications#all_destroy', as: 'notifications_destory'
  post 'recommends', to: 'recommends#recommend_user_display', as: 'recommend_user_display'
  get 'recommend/modal', to: 'recommends#recommend_open_modal', as: 'recommend_open'

  get 'dms', to: 'dms#show', as: 'dm_show'
end
