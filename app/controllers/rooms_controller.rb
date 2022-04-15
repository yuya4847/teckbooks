class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :room_exist?, only: [:show]

  def create
    @room = Room.create
    @entry1 = Entry.create(user_id: current_user.id, room_id: @room.id)
    @entry2 = Entry.create(entry_params)
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    @title = "DM(#{@room.entries[1].user.username})"
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @entries = @room.entries
      @message = Message.new
      @messages = @room.messages
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:notice] = "DMを削除しました。"
    redirect_to userpage_path(current_user)
  end

  private

  def entry_params
    params.require(:entry).permit(
      :user_id,
      :room_id
    ).merge(room_id: @room.id)
  end

  def room_exist?
    unless Room.exists?(id: params[:id])
      flash[:alert] = "メッセージはありません"
      redirect_to root_path
    end
  end
end
