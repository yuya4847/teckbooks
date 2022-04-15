class ReviewsController < ApplicationController
  REAOMMEND_USERS = 5
  RELATED_REVIRES_COUNT = 7
  before_action :authenticate_user!, only: [:index, :all_reviews, :new, :create, :show, :edit, :update, :review_destroy]
  before_action :review_exist?, only: [:show, :edit]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_or_current_user, only: :review_destroy
  impressionist actions: [:show]

  def index
    @q = Review.ransack(params[:q])
    @ranking_reviews = Review.includes(:liked_users).sort { |a, b| b.liked_users.size <=> a.liked_users.size }.first(10)
    @top_pv_reviews = Review.find_top_pv_reviews
    all_tags = ["ruby", "rails", "php", "laravel", "python", "django", "go", "java", "javascript", "typescript", "aws", "docker", "linux", "sql", "vue", "react", "html", "kurbenetes", "swift", "flutter"]
    if params[:search_word]
      if all_tags.include?(params[:search_word])
        @search_word = "#{params[:search_word]}_search_tag"
      else
        @search_word = "other_search_tag"
      end
    end
    if params[:q]
      @reviews = @q.result(distinct: true)
      render :search_result
    end
  end

  def tag_search
    if params[:id] == "その他"
      @reviews = Review.includes(:tags).where.not(tags: { name: ["ruby", "rails", "php", "laravel", "python", "django", "go", "java", "javascript", "typescript", "aws", "docker", "linux", "sql", "vue", "react", "html", "kurbenetes", "swift", "flutter"] })
      render 'reviews/search_result'
    else
      @tag = Tag.find_by(name: params[:id])
      @reviews = @tag.reviews
      render 'reviews/search_result'
    end
  end

  def all_reviews
    @reviews = Review.all.includes(:user).page(params[:page]).per(6)
    @will_recommend_users = User.not_user(current_user)
    @ranking_reviews = Review.includes(:liked_users).sort { |a, b| b.liked_users.size <=> a.liked_users.size }.first(10)
    @top_pv_reviews = Review.find_top_pv_reviews
    @recommends = Recommend.all
    @browsing_histories = BrowsingHistory.order(created_at: :desc).where(user_id: current_user.id)
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
    @recommends = Recommend.all
    @will_recommend_users = User.not_user(current_user)
    @top_pv_reviews = Review.find_top_pv_reviews
    @ranking_reviews = Review.includes(:liked_users).sort { |a, b| b.liked_users.size <=> a.liked_users.size }.first(10)
    impressionist(@review, nil, unique: [:session_hash])
    @user = @review.user
    @comment = Comment.new
    @comments = @review.comments
    @related_reviews = []
    @review.tags.each do |related_tag|
      related_tag.reviews.each do |review|
        @related_reviews.push(review)
      end
    end
    @related_reviews.delete(@review)
    @related_reviews = @related_reviews.sample(RELATED_REVIRES_COUNT)

    new_history = @review.browsing_histories.new
    new_history.user_id = current_user.id
    if current_user.browsing_histories.exists?(review_id: "#{params[:id]}")
      old_history = current_user.browsing_histories.find_by(review_id: "#{params[:id]}")
      old_history.destroy
    end
    new_history.save

    histories_stock_limit = 6
    histories = current_user.browsing_histories.all
    if histories.count > histories_stock_limit
      histories[0].destroy
    end

    @browsing_histories = BrowsingHistory.order(created_at: :desc).where(user_id: current_user.id)
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
      redirect_to userpage_path(current_user)
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
    if @review.user == current_user || current_user.admin?
    else
      flash[:notice] = "この投稿は削除できません。"
      redirect_to root_path
    end
  end
end
