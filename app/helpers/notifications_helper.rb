module NotificationsHelper
  def notification_form(notification)
    case notification.action
    when 'follow'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id)) + 'があなたをフォローしました'
    when 'like'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id)) + 'が' + tag.a('あなたの投稿', href: review_path(notification.review.id)) + 'にいいねしました'
    when 'report'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id)) + 'が' + tag.a('あなたの投稿', href: review_path(notification.review.id)) + 'を通報しました。'
    when 'comment'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id)) + 'が' + tag.a('あなたの投稿', href: review_path(notification.review.id)) + 'にコメントしました。' + "(#{notification.comment.content})"
    when 'response_comment'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id)) + 'が' + tag.a("#{notification.review.title}", href: review_path(notification.review.id)) + 'のあなたのコメントにコメントしました。' + "(#{notification.rescomment.content})"
    when 'recommend'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id)) + 'が' + tag.a("#{notification.review.title}", href: review_path(notification.review.id)) + 'をあなたにリコメンドしました。'
    when 'dm'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id)) + 'があなたにメッセージを送りました。' + "(#{notification.dm_message.content})"
    end
  end

  def unchecked_notifications
    notifications = current_user.passive_notifications.where(checked: false)
  end
end
