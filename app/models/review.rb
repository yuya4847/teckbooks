class Review < ApplicationRecord
  is_impressionable
  mount_uploader :picture, PictureUploader
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships
  has_many :browsing_histories, dependent: :destroy
  has_many :recent_users, through: :browsing_histories, source: :user
  has_many :reports, dependent: :destroy
  has_many :recommends, dependent: :destroy
  has_many :notifications, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validate :rate_custom_error
  validates :content, presence: true, length: { maximum: 250 }
  validate  :picture_size

  scope :find_top_pv_reviews, -> { find(Impression.group(:impressionable_id).pluck(:impressionable_id)).sort {|a,b| b.impressionist_count <=> a.impressionist_count}.first(3) }

    def create_notification_recommend!(visitor_user, visited_user)
      previous_notification = Notification.where(["visitor_id = ? and visited_id = ? and review_id = ? and action = ?",
                                visitor_user.id, visited_user.id, self.id, "recommend"])

      new_notification = visitor_user.active_notifications.create(
        visited_id: visited_user.id,
        review_id: self.id,
        action: "recommend"
      )
      unless visitor_user == visited_user
        visited_notification_count = Notification.where(["visited_id = ? and checked = ?", visited_user.id, false]).size
        if visited_notification_count % 5 == 0
          NotificationMailer.notification_new_storage(visited_user).deliver_now
        end
      end
    end

    def create_notification_response_comment!(visitor_user, response_comment)
      new_notification = visitor_user.active_notifications.new(
        visited_id: response_comment.parent.user.id,
        review_id: self.id,
        comment_id: response_comment.parent.id,
        response_comment_id: response_comment.id,
        action: "response_comment"
      )
      if new_notification.visitor_id == new_notification.visited_id
        new_notification.checked = true
      end
      new_notification.save
      visited_user = response_comment.parent.user
      unless visitor_user == visited_user
        visited_notification_count = Notification.where(["visited_id = ? and checked = ?", visited_user.id, false]).size
        if visited_notification_count % 5 == 0
          NotificationMailer.notification_new_storage(visited_user).deliver_now
        end
      end
    end

    def create_notification_comment!(visitor_user, comment)
      new_notification = visitor_user.active_notifications.new(
        visited_id: self.user.id,
        review_id: self.id,
        comment_id: comment.id,
        action: "comment"
      )
      if new_notification.visitor_id == new_notification.visited_id
        new_notification.checked = true
      end
      new_notification.save
      visited_user = self.user
      unless visitor_user == visited_user
        visited_notification_count = Notification.where(["visited_id = ? and checked = ?", visited_user.id, false]).size
        if visited_notification_count % 5 == 0
          NotificationMailer.notification_new_storage(visited_user).deliver_now
        end
      end
    end

    def create_notification_report!(visitor_user)
      previous_notification = Notification.where(["visitor_id = ? and visited_id = ? and review_id = ? and action = ? ",
                                visitor_user.id, self.user.id, self.id, "report"])
      if previous_notification.blank?
        new_notification = visitor_user.active_notifications.new(
          visited_id: self.user.id,
          review_id: self.id,
          action: "report"
        )
        if new_notification.visitor_id == new_notification.visited_id
          new_notification.checked = true
        end
        new_notification.save
        visited_user = self.user
        unless visitor_user == visited_user
          visited_notification_count = Notification.where(["visited_id = ? and checked = ?", visited_user.id, false]).size
          if visited_notification_count % 5 == 0
            NotificationMailer.notification_new_storage(visited_user).deliver_now
          end
        end
      end
    end

    def create_notification_like!(visitor_user)
      previous_notification = Notification.where(["visitor_id = ? and visited_id = ? and review_id = ? and action = ? ",
                                visitor_user.id, self.user.id, self.id, "like"])
      if previous_notification.blank?
        new_notification = visitor_user.active_notifications.new(
          visited_id: self.user.id,
          review_id: self.id,
          action: "like"
        )
        if new_notification.visitor_id == new_notification.visited_id
          new_notification.checked = true
        end
        new_notification.save
        visited_user = self.user
        unless visitor_user == visited_user
          visited_notification_count = Notification.where(["visited_id = ? and checked = ?", visited_user.id, false]).size
          if visited_notification_count % 5 == 0
            NotificationMailer.notification_new_storage(visited_user).deliver_now
          end
        end
      end
    end

    def save_tags(save_review_tags)
      current_tags = self.tags.pluck(:name) unless self.tags.nil?
      old_tags = current_tags - save_review_tags
      new_tags = save_review_tags - current_tags

      old_tags.uniq.each do |old_name|
        self.tags.delete Tag.find_by(name: old_name)
      end

      new_tags.uniq.each do |new_name|
        review_tag = Tag.find_or_create_by(name: new_name)
        TagRelationship.create(review_id: self.id, tag_id: review_tag.id)
      end
    end

    def like_by(user)
     likes.create(user_id: user.id)
    end

    def unlike_by(user)
      likes.find_by(user_id: user.id).destroy
    end

    def like_by?(user)
      liked_users.include?(user)
    end

  private

    def rate_custom_error
      if rate.blank?
        errors.add(:rate, "を入力してください")
      elsif rate <= 0 || rate >= 6
        errors.add(:rate, "は1以上5以下の値にしてください")
      elsif !rate.is_a?(Integer)
        errors.add(:rate, "は数値で入力してください")
      end
    end

    # アップロード画像のサイズを検証する
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
