module NotificationsHelper
  def notification_form(notification)
    case notification.action
    when 'follow'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id), class: "notification-link") + 'があなたをフォローしました'
    when 'like'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id), class: "notification-link") + 'が' + tag.a('あなたの投稿', href: review_path(notification.review.id), class: "notification-link") + 'にいいねしました'
    when 'report'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id), class: "notification-link") + 'が' + tag.a('あなたの投稿', href: review_path(notification.review.id), class: "notification-link") + 'を通報しました。'
    when 'comment'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id), class: "notification-link") + 'が' + tag.a('あなたの投稿', href: review_path(notification.review.id), class: "notification-link") + 'にコメントしました。' + tag.span("#{truncate(notification.comment.content, length: 20)}", class: "notification-each-comment")
    when 'response_comment'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id), class: "notification-link") + 'が' + tag.a('あなたの投稿', href: review_path(notification.review.id), class: "notification-link") + 'のあなたのコメントにコメントしました。' + "(#{truncate(notification.rescomment.content, length: 10)})"
    when 'recommend'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id), class: "notification-link") + 'が' + tag.a('あなたの投稿', href: review_path(notification.review.id), class: "notification-link") + 'をあなたにリコメンドしました。'
    when 'dm'
      tag.a(notification.visitor.username, href: userpage_path(notification.visitor.id), class: "notification-link") + 'があなたにメッセージを送りました。' + "(#{truncate(notification.dm_message.content, length: 7)})"
    end
  end

  def unchecked_notifications
    notifications = current_user.passive_notifications.where(checked: false)
  end
end
