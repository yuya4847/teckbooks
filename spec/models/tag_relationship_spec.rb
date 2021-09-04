require 'rails_helper'

RSpec.describe TagRelationship, type: :model do
  let!(:user) { create(:user) }
  let!(:good_review) { create(:good_review) }
  let!(:tag) { create(:tag) }
  let!(:tag_relationship) { build(:tag_relationship) }

  describe '#new' do
    it "review_id、tag_idがある場合、有効であること" do
      tag_relationship.valid?
      expect(tag_relationship.valid?).to eq(true)
    end

    it "review_idがnilの場合、無効であること" do
      tag_relationship.review_id = nil
      tag_relationship.valid?
      expect(tag_relationship.valid?).to eq(false)
    end

    it "tag_idがnilの場合、無効であること" do
      tag_relationship.tag_id = nil
      tag_relationship.valid?
      expect(tag_relationship.valid?).to eq(false)
    end
  end

  describe '#destroy' do
    it "削除できること" do
      tag_relationship.save
      expect do
        tag_relationship.destroy
      end.to change(TagRelationship, :count).by(-1)
    end

    it "レビューの削除と同時に削除されること" do
      tag_relationship.save
      expect do
        good_review.destroy
      end.to change(TagRelationship, :count).by(-1)
    end

    it "タグの削除と同時に削除されること" do
      tag_relationship.save
      expect do
        tag.destroy
      end.to change(TagRelationship, :count).by(-1)
    end
  end
end
