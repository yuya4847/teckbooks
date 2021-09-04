require 'rails_helper'

RSpec.describe Tag, type: :model do
  let!(:tag) { build(:tag) }

  describe '#new' do
    it "nameがある場合、有効であること" do
      tag.valid?
      expect(tag.valid?).to eq(true)
    end

    it "nameがない場合、無効であること" do
      tag.name = nil
      tag.valid?
      expect(tag.valid?).to eq(false)
      expect(tag.errors[:name]).to include('を入力してください')
    end

    it "nameが重複する場合、無効であること" do
      tag.name = "Ruby"
      tag.save
      another_tag = build(:tag, name: "Ruby")
      another_tag.save
      another_tag.valid?
      expect(another_tag.valid?).to eq(false)
      expect(another_tag.errors[:name]).to include("はすでに存在します")
    end

    it "nameが文字数を超える場合、無効であること" do
      tag.name = "a" * 11
      tag.valid?
      expect(tag.valid?).to eq(false)
      expect(tag.errors[:name]).to include("は10文字以内で入力してください")
    end
  end

  describe '#edit' do
    it "適切な値で編集できること" do
      tag.save
      tag.name = "Ruby"
      expect(tag.save).to be_truthy
    end

    xit "不正なデータでは編集できないこと" do
      tag.save
      tag.name = ""
      expect(tag.save).not_to be_truthy
      expect(tag.errors[:name]).to include("を入力してください")
      tag.name = "a" * 11
      expect(tag.save).not_to be_truthy
      expect(tag.errors[:name]).to include("は10文字以上で入力してください")
    end
  end

  describe '#destroy' do
    it "削除できること" do
      tag.save
      expect do
        tag.destroy
      end.to change(Tag, :count).by(-1)
    end
  end
end
