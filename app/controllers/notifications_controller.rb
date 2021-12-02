class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :destory]

  def index
    @notifications = Notification.where(visited_id: current_user.id)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def all_destroy
    current_user.passive_notifications.destroy_all
    @notifications = []
    render :index
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    @notifications = Notification.where(visited_id: current_user.id)
    render :index
  end
end
