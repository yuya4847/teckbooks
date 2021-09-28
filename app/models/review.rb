class Review < ApplicationRecord
  is_impressionable
  mount_uploader :picture, PictureUploader
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many  :tag_relationships, dependent: :destroy
  has_many  :tags, through: :tag_relationships
  has_many :browsing_histories, dependent: :destroy
  has_many  :recent_users, through: :browsing_histories, source: :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validate :rate_custom_error
  validates :content, presence: true, length: { maximum: 250 }
  validate  :picture_size

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
