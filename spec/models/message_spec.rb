require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#new' do
    let!(:user) { create(:user) }
    let!(:room) { create(:room) }
    let!(:message) { build(:message, content: "おはようございます！") }

    it "user_id、room_id, contentがある場合、有効であること" do
      message.valid?
      expect(message.valid?).to eq(true)
    end

    it "user_idがnilの場合、無効であること" do
      message.user_id = nil
      message.valid?
      expect(message.valid?).to eq(false)
    end

    it "room_idがnilの場合、無効であること" do
      message.room_id = nil
      message.valid?
      expect(message.valid?).to eq(false)
    end

    it "contentがnilの場合、無効であること" do
      message.content= nil
      message.valid?
      expect(message.valid?).to eq(false)
    end
  end

  describe '#destroy' do
    let!(:user) { create(:user) }
    let!(:room) { create(:room) }
    let!(:message) { build(:message, content: "おはようございます！") }

    it "削除できること" do
      message.save
      expect do
        message.destroy
      end.to change(Message, :count).by(-1)
    end

    it "userと同時に削除されること" do
      message.save
      expect do
        user.destroy
      end.to change(Message, :count).by(-1)
    end

    it "roomと同時に削除されること" do
      message.save
      expect do
        room.destroy
      end.to change(Message, :count).by(-1)
    end
  end
end
