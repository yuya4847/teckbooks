Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }
  devise_scope :user do
    get '/users', to: 'users/registrations#new'
  end
  get '/homes/guest_sign_in', to: 'homes#guest_sign_in', as: 'guest_sign_in'
  get '/homes/guest_sign_in_review_show/:id', to: 'homes#guest_sign_in_review_show', as: 'guest_sign_in_review_show'
  root 'homes#home'
  get 'homes/search', to: 'homes#search'
  get 'homes/terms', to: 'homes#terms', as: 'show_terms'
  get 'homes/privacy_policy', to: 'homes#privacy_policy', as: 'show_privacy_policy'
  get 'homes/suggest', to: 'homes#suggest'
  post 'review_like/create', to: 'like#create', as: 'like_from_allreviews'
  post 'review_like/destroy', to: 'like#destroy', as: 'not_like_from_allreviews'
  post 'reviews/show_review_like/create', to: 'like#create', as: 'like_from_showreview'
  post 'reviews/show_review_like/destroy', to: 'like#destroy', as: 'not_like_froms_showreview'
  post 'review_follow/create', to: 'follow#create', as: 'follow_from_allreviews'
  post 'review_follow/destroy', to: 'follow#destroy', as: 'unfollow_from_allreviews'
  post 'reviews/review_show_follow/create', to: 'follow#create', as: 'follow_from_showreview'
  post 'reviews/review_show_follow/destroy', to: 'follow#destroy', as: 'unfollow_from_showreview'
  post 'userpages/review_follow/create', to: 'follow#create', as: 'follow_from_userpage_profile'
  post 'userpages/review_follow/destroy', to: 'follow#destroy', as: 'unfollow_from_userpage_profile'
  post 'userpages/profile_reviews/review_follow/create', to: 'follow#create', as: 'follow_from_userpage_profile_reviews'
  post 'userpages/profile_reviews/review_follow/destroy', to: 'follow#destroy', as: 'unfollow_from_userpage_profile_reviews'

  resources :userpages,     only: [:show]
  delete 'userpages/:id', to: 'userpages#avatar_destroy'
  get 'userpages/profile_reviews/:id', to: 'userpages#profile_reviews', as: 'profile_reviews'
  get 'userpages/:id/following', to: 'userpages#following', as: 'following_user'
  get 'userpages/:id/followers', to: 'userpages#followers', as: 'followers_user'
  resources :reviews do
    resources :comments, only: [:create, :destroy]
  end
  get 'all_reviews', to: 'reviews#all_reviews', as: 'all_reviews'
  get 'tag_index', to: 'reviews#tag_index', as: 'tag_index'
  post 'tag_search_review/:id', to: 'reviews#tag_search', as: 'tag_search_reviews'
  post 'reviews/response/create', to: 'comments#response_create', as: 'response_comment_create'
  post 'reviews/response/destroy', to: 'comments#response_destroy', as: 'response_comment_destroy'
  delete 'comments/response_comments/:id', to: 'comments#response_destroy', as: 'response_comment'
  delete 'reviews/:id/:original_page', to: 'reviews#review_destroy', as: 'review_destroy'
  resources :likes, only: [:create, :destroy]
  resources :reports, only: [:create]
  post 'reviews/reports', to: 'reports#create'
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show, :destroy]
  resources :notifications, only: [:index, :destroy]
  delete 'notification_all_destory', to: 'notifications#all_destroy', as: 'notifications_destory'
  post 'recommends', to: 'recommends#recommend_user_display', as: 'recommend_user_display'
  get 'recommend/modal', to: 'recommends#recommend_open_modal', as: 'recommend_open'
  post 'reviews/recommends', to: 'recommends#recommend_user_display', as: 'recommend_user_display_from_show'
  get 'reviews/recommend/modal', to: 'recommends#recommend_open_modal', as: 'recommend_open_from_show'
  get 'dms', to: 'dms#show', as: 'dm_show'
end
