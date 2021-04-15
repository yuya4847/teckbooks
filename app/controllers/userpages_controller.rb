class UserpagesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :avatar_destroy]

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
  end

  def avatar_destroy
    user = User.find(params[:id])
    if user == current_user
      user.remove_avatar!
      user.save
      flash[:notice] = "アバターを取り消しました"
      redirect_to userpage_path
    end
  end
end
