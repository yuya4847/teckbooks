require 'rails_helper'

RSpec.describe BrowsingHistory, type: :model do
  let!(:user) { create(:user) }
  let!(:good_review) { create(:good_review) }
  let(:browsing_history) { build(:browsing_history, user_id: user.id, review_id: good_review.id) }

  describe '#new' do
    it "user_id、review_idがある場合、有効であること" do
      browsing_history.valid?
      expect(browsing_history.valid?).to eq(true)
    end

    it "user_idがnilの場合、無効であること" do
      browsing_history.user_id = nil
      browsing_history.valid?
      expect(browsing_history.valid?).to eq(false)
    end

    it "review_idがnilの場合、無効であること" do
      browsing_history.review_id = nil
      browsing_history.valid?
      expect(browsing_history.valid?).to eq(false)
    end
  end

  describe '#destroy' do
    it "削除できること" do
      browsing_history.save
      expect do
        browsing_history.destroy
      end.to change(BrowsingHistory, :count).by(-1)
    end

    it "ユーザーの削除と同時に削除されること" do
      browsing_history.save
      expect do
        user.destroy
      end.to change(BrowsingHistory, :count).by(-1)
    end

    it "レビューの削除と同時に削除されること" do
      browsing_history.save
      expect do
        good_review.destroy
      end.to change(BrowsingHistory, :count).by(-1)
    end
  end
end
