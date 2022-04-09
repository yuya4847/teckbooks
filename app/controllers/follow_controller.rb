class FollowController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    @user.create_notification_follow!(current_user, @user)
    if (params[:review_id])
      @review = Review.find(params[:review_id])
      follow_results = { follow_review_id: @review.id, follow_user_id: @user.id }
    else
      @followers_count = Relationship.where(followed_id: @user.id).size
      follow_results = { follow_user_id: @user.id, followers_count: @followers_count }
    end
    render json: follow_results
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    if (params[:review_id])
      @review = Review.find(params[:review_id])
      not_follow_results = { not_follow_review_id: @review.id, not_follow_user_id: @user.id }
    else
      @followers_count = Relationship.where(followed_id: @user.id).size
      not_follow_results = { not_follow_user_id: @user.id, followers_count: @followers_count }
    end
    render json: not_follow_results
  end
end
