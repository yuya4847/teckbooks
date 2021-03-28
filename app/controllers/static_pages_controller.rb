class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @current_user = current_user
    end
  end
end
