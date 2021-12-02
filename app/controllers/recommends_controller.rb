class RecommendsController < ApplicationController

  def recommend_open_modal
    @review = Review.find(params[:review_id])
    @recommend_user_ids = Recommend.where(recommend_user_id: current_user.id, review_id: @review.id).pluck(:recommended_user_id).map(&:to_i)
    contents = { click_user_ids: @recommend_user_ids}
    render json: contents
  end

  def recommend_user_display
    @review = Review.find(params[:review_id])

    current_user_recommends = Recommend.where(recommend_user_id: current_user.id, review_id: @review.id)

    current_recommends = current_user_recommends.pluck(:recommended_user_id)
    save_recommends = params[:recommend_user_datas].split(',').map(&:to_i)

    new_recommends = save_recommends - current_recommends
    old_recommends = current_recommends - save_recommends

    old_recommends.each do |old_recommend|
      Recommend.destroy_by(recommend_user_id: current_user.id, recommended_user_id: old_recommend, review_id: @review.id)
    end

    new_recommends.each do |new_recommend|
      Recommend.create(recommend_user_id: current_user.id, recommended_user_id: new_recommend, review_id: @review.id)
      @review.create_notification_recommend!(current_user, User.find(new_recommend))
    end

    contents = { review_id: @review.id}
    render json: contents
  end
end
