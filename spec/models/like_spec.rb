require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { create(:user) }
  let!(:good_review) { create(:good_review) }
  let(:like) { build(:like, user_id: user.id, review_id: good_review.id) }

  describe '#new' do
    it "user_id、review_idがある場合、有効であること" do
      like.valid?
      expect(like.valid?).to eq(true)
    end

    it "user_idがnilの場合、無効であること" do
      like.user_id = nil
      like.valid?
      expect(like.valid?).to eq(false)
    end

    it "review_idがnilの場合、無効であること" do
      like.review_id = nil
      like.valid?
      expect(like.valid?).to eq(false)
    end
  end

  describe '#destroy' do
    it "削除できること" do
      like.save
      expect do
        like.destroy
      end.to change(Like, :count).by(-1)
    end

    it "ユーザーの削除と同時に削除されること" do
      like.save
      expect do
        user.destroy
      end.to change(Like, :count).by(-1)
    end

    it "レビューの削除と同時に削除されること" do
      like.save
      expect do
        good_review.destroy
      end.to change(Like, :count).by(-1)
    end
  end
end
