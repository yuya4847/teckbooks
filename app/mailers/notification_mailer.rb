class NotificationMailer < ApplicationMailer
  def notification_new_storage(user)
    @user = user
    @notification_count = @user.passive_notifications.size
    mail to: user.email, subject: "未閲覧の通知に関して"
  end
end
