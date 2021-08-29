class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.review_id = params[:review_id]
    if @comment.save
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
    if @comment.save
      render :index
    end
  end

  def response_destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render :index
    end
  end

  def cancel_response
    @comment = Comment.find(params[:id])
    render :response_cancel
  end

  def cancel_comment
    render :comment_cancel
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
