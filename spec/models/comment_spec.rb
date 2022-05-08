require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user, id: 1) }
  let!(:good_review) { create(:good_review, id: 1) }
  let!(:comment) { build(:comment, id: 1) }

  describe '#new' do
    it "reviewを作成できること" do
      expect(comment.valid?).to eq(true)
    end

    it "contentがない場合、commentを作成できないこと" do
      comment.content = nil
      expect(comment.valid?).to eq(false)
    end

    it "user_idがない場合、commentを作成できないこと" do
      comment.user_id = nil
      expect(comment.valid?).to eq(false)
    end

    it "review_idがない場合、commentを作成できないこと" do
      comment.review_id = nil
      expect(comment.valid?).to eq(false)
    end

    it "titleが文字数超えの場合、reviewを作成できないこと" do
      comment.content = "a" * 501
      comment.valid?
      expect(comment.errors[:content]).to include('は500文字以内で入力してください')
    end

    it "順番は最新のものが最初であること" do
      @old_comment = create(:comment, created_at: 10.minutes.ago)
      @recent_comment = create(:comment, created_at: 5.minutes.ago)
      expect(@recent_comment).to eq(Comment.first)
    end
  end

  describe '#destroy' do
    it "削除できること" do
      comment.save
      expect do
        comment.destroy
      end.to change(Comment, :count).by(-1)
    end

    it "reviewが削除されると関連づけられたcommentも削除されること" do
      comment.save
      expect{ good_review.destroy }.to change{ Comment.count }.by(-1)
    end

    it "親コメントが削除されるとその返信コメントも削除されること" do
      comment.save
      create(:comment, user_id: user.id, review_id: good_review.id, parent_id: comment.id)
      expect{ comment.destroy }.to change{ Comment.count }.by(-2)
    end

    it "userが削除されたとしても関連づけられたcommentも削除されないこと" do
      comment.save
      expect{ user.destroy }.to change{ Comment.count }.by(-1)
    end
  end
end
