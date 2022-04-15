class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  has_one :rule
  after_create :build_default_rule
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_reviews, through: :likes
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :browsing_histories, dependent: :destroy
  has_many :recent_reviews, through: :browsing_histories, source: :review
  has_many :reports, dependent: :destroy
  has_many :active_recommends, class_name:  "Recommend",
                                  foreign_key: "recommend_user_id",
                                  dependent:   :destroy
  has_many :passive_recommends, class_name:  "Recommend",
                                  foreign_key: "recommended_user_id",
                                  dependent:   :destroy
  has_many :active_notifications, foreign_key: "visitor_id", class_name: "Notification", dependent: :destroy
  has_many :passive_notifications, foreign_key: "visited_id", class_name: "Notification", dependent: :destroy
  before_save { self.email = email.downcase }
  validates :username, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: Const::VALID_EMAIL_REGEX }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password, allow_blank: true, confirmation: true, length: { minimum: 6 }, on: :update
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable,
         :timeoutable, :trackable
  enum sex: { man: 0, woman: 1 }
  validates :profile, length: { maximum: 255 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable,
         :timeoutable, :trackable
  validate  :avatar_size

  scope :not_user, ->(user) { where.not(id: user.id) }

  def create_notification_follow!(visitor_user, visited_user)
    previous_notification = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", visitor_user.id, self.id, 'follow'])

    if previous_notification.blank?
      new_notification = visitor_user.active_notifications.new(
        visited_id: visited_user.id,
        action: 'follow'
      )
      new_notification.save
      unless visitor_user == visited_user
        visited_notification_count = Notification.where(["visited_id = ? and checked = ?", visited_user.id, false]).size
        if visited_notification_count % 5 == 0
          NotificationMailer.notification_new_storage(visited_user).deliver_now
        end
      end
    end
  end

  # allow users to update their accounts without passwords
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def already_report?(review)
    self.reports.exists?(review_id: review.id)
  end

  private

  # アップロードされた画像のサイズをバリデーションする
  def avatar_size
    if avatar.size > 5.megabytes
      errors.add(:avatar, "should be less than 5MB")
    end
  end

  def build_default_rule
    case id
      when 1
        Rule.create(user_id: id, rule_name: "admin")
      when 2
        Rule.create(user_id: id, rule_name: "sample")
      else
        Rule.create(user_id: id, rule_name: "general")
    end
  end
end
