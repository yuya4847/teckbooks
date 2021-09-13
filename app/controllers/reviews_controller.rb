class ReviewsController < ApplicationController
  REAOMMEND_USERS = 5
  before_action :authenticate_user!, only: [:index, :all_reviews, :new, :create, :show, :edit, :update, :review_destroy]
  before_action :review_exist?,       only: [:show, :edit]
  before_action :correct_user,       only: [:edit, :update]
  before_action :admin_or_current_user,     only: :review_destroy

  def index
    @q = Review.ransack(params[:q])
    if params[:q]
      @reviews = @q.result(distinct: true)
      render :search_result
    end
  end

  def tag_search
    if params[:id] == "その他"
      @reviews = Review.includes(:tags)
      .where.not(tags: { name: "ruby" })
      .where.not(tags: { name: "rails" })
      .where.not(tags: { name: "php" })
      .where.not(tags: { name: "python" })
      .where.not(tags: { name: "go" })
      .where.not(tags: { name: "java" })
      .where.not(tags: { name: "javascript" })
      .where.not(tags: { name: "typescript" })
      .where.not(tags: { name: "aws" })
      .where.not(tags: { name: "docker" })
      .where.not(tags: { name: "linux" })
      .where.not(tags: { name: "sql" })
      .where.not(tags: { name: "vue" })
      .where.not(tags: { name: "react" })
      render 'reviews/search_result'
    else
      @tag = Tag.find_by(name: params[:id])
      @reviews = @tag.reviews
      render 'reviews/search_result'
    end
  end

  def all_reviews
    @reviews = Review.all
    @ranking_reviews = Review.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}.first(3)
    @recommend_users = User.where.not("id IN (:follow_ids) OR id = :current_id",
    follow_ids: current_user.following.ids,
    current_id: current_user).shuffle.take(REAOMMEND_USERS)
  end

  def new
    @review = current_user.reviews.build
  end

  def create
    @review = current_user.reviews.build(review_params)
    tag_lists = params[:review][:tag_ids].split(',') if params[:review][:tag_ids]
    if tag_lists
      tag_lists.each_with_index do |tag_list, i|
        tag_lists[i] = tag_list.downcase
      end
    end
    if @review.save
      @review.save_tags(tag_lists) if tag_lists
      flash[:notice] = "レビューを投稿しました"
      redirect_to userpage_path(current_user.id)
    else
      render new_review_path
    end
  end

  def show
    @review = Review.find(params[:id])
    @user = @review.user
    @comment = Comment.new
    @comments = @review.comments
  end

  def edit
    @review = Review.find(params[:id])
    @tag_list = @review.tags.pluck(:name).join(",")
  end

  def update
    @review = Review.find(params[:id])
    if params[:review][:tag_ids]
      tag_lists = params[:review][:tag_ids].split(',')
      tag_lists.each_with_index do |tag_list, i|
        tag_lists[i] = tag_list.downcase
      end
    end
    if @review.update(review_params)
      @review.save_tags(tag_lists) if tag_lists
      flash[:notice] = "投稿を編集しました。"
      redirect_to userpage_path(@review.user)
    else
      render 'edit'
    end
  end

  def review_destroy
    @review = Review.find(params[:id])
    @review.destroy
    flash[:notice] = "投稿を削除しました。"
    if params[:original_page] == "exist"
      redirect_back(fallback_location: root_path)
    else
      redirect_to userpage_path(@review.user)
    end
  end

  private

    def review_params
      params.require(:review).permit(
        :picture,
        :content,
        :rate,
        :title,
        :link
      )
    end

    def review_exist?
      unless Review.exists?(id: params[:id])
        flash[:alert] = "レビューは存在しません。"
        redirect_to root_path
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @review = Review.find(params[:id])
      unless @review.user == current_user
        flash[:notice] = "この投稿は編集できません。"
        redirect_to root_path
      end
    end

    def admin_or_current_user
      @review = Review.find(params[:id])
      unless @review.user == current_user || current_user.admin?
        flash[:notice] = "この投稿は削除できません。"
        redirect_to root_path
      end
    end
end
