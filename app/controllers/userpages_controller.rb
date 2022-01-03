class UserpagesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :avatar_destroy, :following, :followers]
  before_action :user_exist?,       only: [:show, :following, :followers]
  before_action :correct_user,       only: [:avatar_destroy]

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
    @reviews = @user.reviews
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
