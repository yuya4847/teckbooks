require 'rails_helper'

RSpec.describe Room, type: :model do
  let!(:user) { create(:user) }
  let!(:room) { build(:room) }

  describe '#new' do
    it "roomを作成できること" do
      expect(room.valid?).to eq(true)
    end

    it "nameがなくとも作成することができること" do
      room.name = nil
      expect(room.valid?).to eq(true)
    end

    it "titleが文字数超えの場合、reviewを作成できないこと" do
      room.name = "a" * 16
      room.valid?
      expect(room.errors[:name]).to include('は15文字以内で入力してください')
    end
  end

  describe '#destroy' do
    it "削除できること" do
      room.save
      expect do
        room.destroy
      end.to change(Room, :count).by(-1)
    end
  end
end
