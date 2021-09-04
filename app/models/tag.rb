class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy
  has_many :reviews, through: :tag_relationships
  validates :name, uniqueness: true, presence: true, length: { maximum: 10 }
end
