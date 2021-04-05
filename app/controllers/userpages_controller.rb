class UserpagesController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  
  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
  end
end
