class UserpagesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :avatar_destroy]

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
  end

  def avatar_destroy
    user = User.find(params[:id])
    user.remove_avatar!
    user.save
    flash[:success] = "アバターの変更に成功しました。"
    redirect_to userpage_path
  end
end
