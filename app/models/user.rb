class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
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
end
