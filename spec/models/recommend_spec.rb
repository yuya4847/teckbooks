require 'rails_helper'

RSpec.describe Recommend, type: :model do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }
  let!(:good_review) { create(:good_review) }
  let!(:recommend) { build(:recommend) }

  describe '#new' do
    it "recommend_user_id、recommended_user_id、review_idがある場合、有効であること" do
      recommend.valid?
      expect(recommend.valid?).to eq(true)
    end

    it "recommend_user_idがnilの場合、無効であること" do
      recommend.recommend_user_id = nil
      recommend.valid?
      expect(recommend.valid?).to eq(false)
    end

    it "recommended_user_idがnilの場合、無効であること" do
      recommend.recommended_user_id = nil
      recommend.valid?
      expect(recommend.valid?).to eq(false)
    end

    it "review_idがnilの場合、無効であること" do
      recommend.review_id = nil
      recommend.valid?
      expect(recommend.valid?).to eq(false)
    end
  end

  describe '#destroy' do
    it "削除できること" do
      recommend.save
      expect do
        recommend.destroy
      end.to change(Recommend, :count).by(-1)
    end

    it "リコメンドしたユーザーの削除と同時に削除されること" do
      recommend.save
      expect do
        user.destroy
      end.to change(Recommend, :count).by(-1)
    end

    it "リコメンドされたユーザーの削除と同時に削除されること" do
      recommend.save
      expect do
        second_user.destroy
      end.to change(Recommend, :count).by(-1)
    end

    it "レビューの削除と同時に削除されること" do
      recommend.save
      expect do
        good_review.destroy
      end.to change(Recommend, :count).by(-1)
    end
  end
end
