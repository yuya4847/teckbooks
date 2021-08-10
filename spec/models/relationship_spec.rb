require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe '#new' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let(:relationship) { build(:relationship) }

    it "follower_id、followed_idがある場合、有効であること" do
      relationship.valid?
      expect(relationship.valid?).to eq(true)
    end

    it "follower_idがnilの場合、無効であること" do
      relationship.follower_id = nil
      relationship.valid?
      expect(relationship.valid?).to eq(false)
    end

    it "followed_idがnilの場合、無効であること" do
      relationship.followed_id = nil
      relationship.valid?
      expect(relationship.valid?).to eq(false)
    end
  end

  describe 'フォローとフォロー解除を適切に行う' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }

    it "フォローができること" do
      expect(user.following?(second_user)).to eq(false)
      user.follow(second_user)
      expect(user.following?(second_user)).to eq(true)
      expect(second_user.followers.include?(user)).to eq(true)
    end

    it "フォロー解除ができること" do
      user.follow(second_user)
      expect(user.following?(second_user)).to eq(true)
      user.unfollow(second_user)
      expect(user.following?(second_user)).to eq(false)
      expect(second_user.followers.include?(user)).to eq(false)
    end
  end
end
