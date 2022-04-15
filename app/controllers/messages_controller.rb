class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(message_params)
      @room = Room.find(params[:message][:room_id])
      @messages = @room.messages
      visited_user = User.find(Entry.where.not(user_id: current_user.id).where(room_id: @room.id).pluck(:user_id))
      @message.create_notification_dm!(current_user, visited_user)
      render :message_create
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def message_params
    params.require(:message).permit(
      :user_id,
      :content,
      :room_id
    ).merge(user_id: current_user.id)
  end
end
