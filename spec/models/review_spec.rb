require 'rails_helper'

RSpec.describe Review, type: :model do
  let!(:user) { create(:user) }
  let(:review) { user.reviews.build(title: "hello", content: "fine", rate: 1) }

  describe '#new' do
    it "reviewを作成できること" do
      expect(review.valid?).to eq(true)
    end

    it "user_idがない場合、reviewを作成できないこと" do
      review.user_id = nil
      expect(review.valid?).to eq(false)
    end

    it "titleがない場合、reviewを作成できないこと" do
      review.title = nil
      review.valid?
      expect(review.errors[:title]).to include('を入力してください')
    end

    it "titleが文字数超えの場合、reviewを作成できないこと" do
      review.title = "a" * 51
      review.valid?
      expect(review.errors[:title]).to include('は50文字以内で入力してください')
    end

    it "rateがない場合、reviewを作成できないこと" do
      review.rate = nil
      review.valid?
      expect(review.errors[:rate]).to include('を入力してください')
    end

    it "rateの値が不適切な場合、reviewを作成できないこと" do
      review.rate = 0
      review.valid?
      expect(review.errors[:rate]).to include('は1以上5以下の値にしてください')
      review.rate = 6
      review.valid?
      expect(review.errors[:rate]).to include('は1以上5以下の値にしてください')
    end

    it "contentがない場合、reviewを作成できないこと" do
      review.content = nil
      review.valid?
      expect(review.errors[:content]).to include('を入力してください')
    end

    it "contentが文字数超えの場合、reviewを作成できないこと" do
      review.content = "a" * 251
      review.valid?
      expect(review.errors[:content]).to include('は250文字以内で入力してください')
    end

    it "順番は最新のものが最初であること" do
      @great_review = create(:great_review)
      @recent_review = create(:recent_review)
      expect(@recent_review).to eq(Review.first)
    end

    it "userが削除されると関連づけられたreviewも削除されること" do
      review.save
      expect{ user.destroy }.to change{ Review.count }.by(-1)
    end

  end

  describe '#destroy' do
    it "削除できること" do
      review.save
      expect do
        review.destroy
      end.to change(Review, :count).by(-1)
    end
  end
end
