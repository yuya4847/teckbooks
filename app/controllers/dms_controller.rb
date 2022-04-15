class DmsController < ApplicationController
  def show
    @current_user_entries = Entry.where(user_id: current_user.id)
  end
end
