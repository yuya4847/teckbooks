class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :show]
  def index
    @reviews = Review.all
  end

  def new
    @review = current_user.reviews.build
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "レビューを投稿しました"
      redirect_to root_path
    else
      render new_review_path
    end
  end

  def show
    @review = Review.find(params[:id])
  end

  private

    def review_params
      params.require(:review).permit(:picture, :content, :rate, :title, :link)
    end
end
