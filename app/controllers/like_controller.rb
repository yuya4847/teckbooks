class LikeController < ApplicationController
  def create
    @review = Review.find(params[:review_id])
    unless @review.like_by?(current_user)
      @review.like_by(current_user)
      @review.create_notification_like!(current_user)
      @ranking_reviews = Review.includes(:liked_users).sort { |a, b| b.liked_users.size <=> a.liked_users.size }.first(9)
      like_contents = { like_review_id: @review.id }
      render json: like_contents
    end
  end

  def destroy
    @review = Like.where(review_id: params[:id], user_id: current_user.id)[0].review
    if @review.like_by?(current_user)
      @review.unlike_by(current_user)
      @ranking_reviews = Review.includes(:liked_users).sort { |a, b| b.liked_users.size <=> a.liked_users.size }.first(9)
      not_like_contents = { not_like_review_id: @review.id }
      render json: not_like_contents
    end
  end
end
