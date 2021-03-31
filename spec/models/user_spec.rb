require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#new' do
    it "username、email、passwordがある場合、有効であること" do
      user = FactoryBot.build(:user)
      user.valid?
      expect(user.valid?).to eq(true)
    end

    it "username、email、password、sex、profileがある場合、有効であること" do
      user = FactoryBot.build(:user, sex: "man", profile: "profile")
      user.valid?
      expect(user.valid?).to eq(true)
    end

    it "usernameがnilの場合、無効であること" do
      user = FactoryBot.build(:user, username: nil)
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:username]).to include("を入力してください")
    end

    it "emailがnilの場合、無効であること" do
      user = FactoryBot.build(:user, email: nil)
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "passwordがnilの場合、無効であること" do
      user = FactoryBot.build(:user, password: nil)
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "passwordが一致しない場合、無効であること" do
      user = FactoryBot.build(:user, password_confirmation: "passwords")
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    it "メールアドレスが重複する場合、無効であること" do
      user = FactoryBot.create(:user, email: "yuya@example.com")
      another_user = FactoryBot.build(:user, email: "yuya@example.com")
      another_user.valid?
      expect(another_user.valid?).to eq(false)
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end

    it "usernameが文字数を超える場合、無効であること" do
      user = FactoryBot.build(:user, username: "a" * 21)
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:username]).to include("は20文字以内で入力してください")
    end

    it "emailが文字数を超える場合、無効であること" do
      user = FactoryBot.build(:user, email: "yuya@example.com" + ("a" * 300))
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("は255文字以内で入力してください")
    end

    it "profileが文字数を超える場合、無効であること" do
      user = FactoryBot.build(:user, profile: "a" * 300)
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:profile]).to include("は255文字以内で入力してください")
    end

    it "passwordが文字数に満たない場合、無効であること" do
      user = FactoryBot.build(:user, password: "a" * 5)
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "メールアドレス形式になっていない場合、無効であること" do
      user = FactoryBot.build(:user, email: "yuyaexample.com")
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("は不正な値です")
      user = FactoryBot.build(:user, email: "yuya@examplecom")
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("は不正な値です")
      user = FactoryBot.build(:user, email: "yuyaexamplecom")
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("は不正な値です")
    end
  end

  describe '#edit' do
    it "必須項目に関して全て適切な値で編集できること" do
      user = FactoryBot.create(:user)
      user.username = "yuyaaaaa"
      user.email = "edityuya@example.com"
      user.password = "edit_password"
      user.password_confirmation = "edit_password"
      expect(user.save).to be_truthy
    end

    it "パスワードはデフォルトのままでも編集できること" do
      user = FactoryBot.create(:user)
      user.username = "yuyaaaaa"
      user.email = "edityuya@example.com"
      user.password = ""
      user.password_confirmation = ""
      expect(user.save).to be_truthy
    end

    it "不正なデータでは編集できないこと" do
      user = FactoryBot.create(:user)
      user.username = ""
      user.email = ""
      user.password = "epswd"
      user.password_confirmation = "cpswd"
      expect(user.save).not_to be_truthy
      expect(user.errors[:username]).to include("を入力してください")
      expect(user.errors[:email]).to include("を入力してください")
      expect(user.errors[:email]).to include("は不正な値です")
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end

  describe '#destroy' do
    it "削除できること" do
      user = FactoryBot.create(:user)
      expect do
        user.destroy
      end.to change(User, :count).by(-1)
    end
  end
end
