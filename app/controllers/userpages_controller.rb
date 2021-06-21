class UserpagesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :avatar_destroy]
  before_action :user_exist?,       only: [:show]
  before_action :correct_user,       only: [:avatar_destroy]

  def show
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

  private

    def user_exist?
      unless User.exists?(id: params[:id])
        flash[:alert] = "ユーザーは存在しません。"
        redirect_to root_path
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:notice] = "現在ログインしているユーザーでは削除できません。"
        redirect_to root_path
      end
    end

end
