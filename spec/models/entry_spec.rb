require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe '#new' do
    let!(:user) { create(:user) }
    let!(:room) { create(:room) }
    let!(:entry) { build(:entry) }

    it "user_id、room_idがある場合、有効であること" do
      entry.valid?
      expect(entry.valid?).to eq(true)
    end

    it "user_idがnilの場合、無効であること" do
      entry.user_id = nil
      entry.valid?
      expect(entry.valid?).to eq(false)
    end

    it "room_idがnilの場合、無効であること" do
      entry.room_id = nil
      entry.valid?
      expect(entry.valid?).to eq(false)
    end
  end

  describe '#destroy' do
    let!(:user) { create(:user) }
    let!(:room) { create(:room) }
    let!(:entry) { build(:entry) }

    it "削除できること" do
      entry.save
      expect do
        entry.destroy
      end.to change(Entry, :count).by(-1)
    end

    it "userと同時に削除されること" do
      entry.save
      expect do
        user.destroy
      end.to change(Entry, :count).by(-1)
    end

    it "roomと同時に削除されること" do
      entry.save
      expect do
        room.destroy
      end.to change(Entry, :count).by(-1)
    end
  end
end
