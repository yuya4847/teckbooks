class LikesController < ApplicationController
  def create
    @review = Review.find(params[:review_id])
    unless @review.like_by?(current_user)
      @review.like_by(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end

  def destroy
    @review = Like.find(params[:id]).review
    if @review.like_by?(current_user)
      @review.unlike_by(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end
end
