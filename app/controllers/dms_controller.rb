class DmsController < ApplicationController

  def show
    @currentUserEntries = Entry.where(user_id: current_user.id)
  end
end
