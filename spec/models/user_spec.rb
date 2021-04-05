require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe '#new' do
    it "username、email、passwordがある場合、有効であること" do
      user.valid?
      expect(user.valid?).to eq(true)
    end

    it "username、email、password、sex、profileがある場合、有効であること" do
      user.sex = "man"
      user.profile = "profile"
      user.valid?
      expect(user.valid?).to eq(true)
    end

    it "usernameがnilの場合、無効であること" do
      user.username = nil
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:username]).to include("を入力してください")
    end

    it "emailがnilの場合、無効であること" do
      user.email = nil
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "passwordがnilの場合、無効であること" do
      user.password = nil
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "passwordが一致しない場合、無効であること" do
      user.password_confirmation = "passwords"
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    it "メールアドレスが重複する場合、無効であること" do
      user.email = "yuya@example.com"
      user.save
      another_user = build(:user, email: "yuya@example.com")
      another_user.save
      another_user.valid?
      expect(another_user.valid?).to eq(false)
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end

    it "usernameが文字数を超える場合、無効であること" do
      user.username = "a" * 21
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:username]).to include("は20文字以内で入力してください")
    end

    it "emailが文字数を超える場合、無効であること" do
      user.email = "yuya@example.com" + ("a" * 300)
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("は255文字以内で入力してください")
    end

    it "profileが文字数を超える場合、無効であること" do
      user.profile = "a" * 300
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:profile]).to include("は255文字以内で入力してください")
    end

    it "passwordが文字数に満たない場合、無効であること" do
      user.password = "a" * 5
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "メールアドレス形式になっていない場合、無効であること" do
      user.email = "yuyaexample.com"
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("は不正な値です")
      user.email = "yuya@examplecom"
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("は不正な値です")
      user.email = "yuyaexamplecom"
      user.valid?
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("は不正な値です")
    end
  end

  describe '#edit' do
    it "必須項目に関して全て適切な値で編集できること" do
      user.save
      user.username = "yuyaaaaa"
      user.email = "edityuya@example.com"
      user.password = "edit_password"
      user.password_confirmation = "edit_password"
      expect(user.save).to be_truthy
    end

    it "パスワードはデフォルトのままでも編集できること" do
      user.save
      user.username = "yuyaaaaa"
      user.email = "edityuya@example.com"
      user.password = ""
      user.password_confirmation = ""
      expect(user.save).to be_truthy
    end

    it "不正なデータでは編集できないこと" do
      user.save
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
      user.save
      expect do
        user.destroy
      end.to change(User, :count).by(-1)
    end
  end
end
