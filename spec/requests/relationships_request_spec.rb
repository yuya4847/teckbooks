RSpec.describe "Relationships", type: :request do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:second_user) }
  let!(:relationship) { build(:relationship) }

  before do
    login_as(user)
  end

  describe "#create" do
    it 'フォローのリクエストが成功する' do
      post relationships_path, params: { followed_id: second_user.id }
      expect(response).to have_http_status(302)
    end

    it 'フォローが1件増える' do
      expect do
        post relationships_path, params: { followed_id: second_user.id }
      end.to change(Relationship, :count).by(1)
    end
  end

  describe "#destroy" do
    it 'アンフォローのリクエストが成功する' do
      relationship.save
      delete relationship_path(relationship.id)
      expect(response).to have_http_status(302)
    end

    it 'フォローが1件減る' do
      relationship.save
      expect do
        delete relationship_path(relationship.id)
      end.to change(Relationship, :count).by(-1)
    end
  end

  describe "#create(ajax)" do
    it 'フォローのリクエストが成功する' do
      post relationships_path, params: { followed_id: second_user.id }, xhr: true
      expect(response).to have_http_status(200)
    end

    it 'フォローが1件増える' do
      expect do
        post relationships_path, params: { followed_id: second_user.id }, xhr: true
      end.to change(Relationship, :count).by(1)
    end
  end

  describe "#destroy(ajax)" do
    it 'アンフォローのリクエストが成功する' do
      relationship.save
      delete relationship_path(relationship.id), xhr: true
      expect(response).to have_http_status(200)
    end

    it 'フォローが1件減る' do
      relationship.save
      expect do
        delete relationship_path(relationship.id), xhr: true
      end.to change(Relationship, :count).by(-1)
    end
  end
end
