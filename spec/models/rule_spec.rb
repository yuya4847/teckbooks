require 'rails_helper'

RSpec.describe Rule, type: :model do
  describe '値の存在性を検証する' do
    let!(:user) { create(:user) }
    let!(:admin_rule) { build(:rule, rule_name: "admin", user_id: user.id) }

    it "user_id, rule_nameが存在するとき、有効であること" do
      expect(admin_rule.valid?).to eq(true)
    end

    it "user_idが存在しないとき、無効であること" do
      admin_rule.user_id = nil
      expect(admin_rule.valid?).to eq(false)
    end

    it "rule_nameが存在しないとき、無効であること" do
      admin_rule.rule_name = nil
      expect(admin_rule.valid?).to eq(false)
    end

    it "rule_nameが存在しないとき、無効であること" do
      admin_rule.rule_name = ""
      expect(admin_rule.valid?).to eq(false)
    end

    it "rule_nameが存在しないとき、無効であること" do
      admin_rule.rule_name = " "
      expect(admin_rule.valid?).to eq(false)
    end
  end

  describe '値の適切性を検証する' do
    let!(:user) { create(:user) }
    let!(:admin_rule) { build(:rule, rule_name: "admin", user_id: user.id) }
    let!(:second_user) { create(:second_user) }
    let!(:sample_rule) { build(:rule, rule_name: "sample", user_id: second_user.id) }
    let!(:third_user) { create(:third_user) }
    let!(:general_rule) { build(:rule, rule_name: "general", user_id: third_user.id) }

    it "rule_nameがadminのとき、有効であること" do
      expect(admin_rule.valid?).to eq(true)
    end

    it "rule_nameがsampleのとき、有効であること" do
      expect(sample_rule.valid?).to eq(true)
    end

    it "rule_nameがgeneralのとき、有効であること" do
      expect(general_rule.valid?).to eq(true)
    end

    it "rule_nameがadmin・sample・generalのどれでもないとき、無効であること" do
      general_rule.rule_name = "aaa"
      expect(general_rule.valid?).to eq(false)
    end
  end

  describe 'ユーザーの作成と同時に、適切なruleが生成されること' do
    let!(:user) { build(:user) }
    let!(:second_user) { build(:second_user) }
    let!(:third_user) { build(:third_user) }

    it "ユーザーの作成と同時にruleが生成されること" do
      expect{ user.save }.to change{ Rule.count }.by(+1)
    end

    it "IDが１のユーザーの作成と共に、admin_ruleが生成され付与されること" do
      user.save
      expect(user.rule.rule_name).to eq("admin")
    end

    it "IDが２のユーザーの作成と共に、sample_ruleが生成され付与されること" do
      user.save
      second_user.save
      expect(second_user.rule.rule_name).to eq("sample")
    end

    it "IDが３のユーザーの作成と共に、general_ruleが生成され付与されること" do
      user.save
      second_user.save
      third_user.save
      expect(third_user.rule.rule_name).to eq("general")
    end
  end
end
