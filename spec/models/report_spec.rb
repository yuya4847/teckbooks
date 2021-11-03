require 'rails_helper'

RSpec.describe Report, type: :model do
  let!(:user) { create(:user) }
  let!(:good_review) { create(:good_review) }
  let(:report) { build(:report, user_id: user.id, review_id: good_review.id) }

  describe '#new' do
    it "user_id、review_idがある場合、有効であること" do
      report.valid?
      expect(report.valid?).to eq(true)
    end

    it "user_idがnilの場合、無効であること" do
      report.user_id = nil
      report.valid?
      expect(report.valid?).to eq(false)
    end

    it "review_idがnilの場合、無効であること" do
      report.review_id = nil
      report.valid?
      expect(report.valid?).to eq(false)
    end
  end

  describe '#destroy' do
    it "削除できること" do
      report.save
      expect do
        report.destroy
      end.to change(Report, :count).by(-1)
    end

    it "ユーザーの削除と同時に削除されること" do
      report.save
      expect do
        user.destroy
      end.to change(Report, :count).by(-1)
    end

    it "レビューの削除と同時に削除されること" do
      report.save
      expect do
        good_review.destroy
      end.to change(Report, :count).by(-1)
    end
  end
end
