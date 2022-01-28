class UserpagesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :profile_reviews, :avatar_destroy, :following, :followers]
  before_action :user_exist?,       only: [:show, :following, :followers]
  before_action :correct_user,       only: [:avatar_destroy]
  REAOMMEND_USERS = 5
  RELATED_REVIRES_COUNT = 7

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @UserEntry = Entry.where(user_id: @user.id)
    if @user.id == current_user.id
      @currentUserEntries = Entry.where(user_id: current_user.id)
    else
      @currentUserEntry.each do |cu|
        @UserEntry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def profile_reviews
    @user = User.find(params[:id])
    @all_reviews = @user.reviews
    @reviews = @user.reviews.page(params[:page]).per(7)

    @following_users = Relationship.where("follower_id IN (:follow_user_ids)",
    follow_user_ids: current_user.following.ids)
    user_ids = []
    @following_users.each do |following_user|
      user_ids << following_user.followed_id
    end
    @may_friend_users = User.not_user(current_user)
    .where.not("id IN (:current_following_ids)",
    current_following_ids: current_user.following.ids)
    .where("id IN (:following_user_ids)",
    following_user_ids: user_ids)

    @unknown_users = User.where.not("id IN (:follow_ids) OR id = :current_id",
    follow_ids: current_user.following.ids,
    current_id: current_user).shuffle.take(REAOMMEND_USERS)
    @unknown_users -= @may_friend_users
  end

  def avatar_destroy
    @user = User.find(params[:id])
    @user.remove_avatar!
    @user.save
    flash[:notice] = "アバターを取り消しました"
    redirect_to userpage_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private

    def user_exist?
      unless User.exists?(id: params[:id])
        flash[:alert] = "ユーザーは存在しません。"
        redirect_to root_path
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:notice] = "現在ログインしているユーザーでは削除できません。"
        redirect_to root_path
      end
    end
end
