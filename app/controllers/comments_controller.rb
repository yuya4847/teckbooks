class CommentsController < ApplicationController
  include ActionView::Helpers::DateHelper
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.review_id = params[:review_id]
    @review = Review.find(params[:review_id])
    if @comment.save
      @review.create_notification_comment!(current_user, @comment)
      render :index
    else
      render :comment_error
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render :index
    end
  end

  def response_create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.review_id = params[:review_id]
    @comment.parent_id = params[:parent_id]
    @review = Review.find(params[:review_id])
    @parent_comment = Comment.find(params[:parent_id])
    if @comment.save
      @review.create_notification_response_comment!(current_user, @comment)
      contents = {
        parent_comment: @parent_comment,
        reponse_comment: @comment,
        response_user: current_user,
        response_comment_date: "#{time_ago_in_words(@comment.created_at).delete("約").delete("未満")}",
      }
      render json: contents
    end
  end

  def response_destroy
    @comment = Comment.find(params[:comment_id])
    if @comment.destroy
      contents = { destroy_comment: @comment }
      render json: contents
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
