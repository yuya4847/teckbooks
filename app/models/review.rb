class Review < ApplicationRecord
  mount_uploader :picture, PictureUploader
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validate :rate_custom_error
  validates :content, presence: true, length: { maximum: 250 }
  validate  :picture_size

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
