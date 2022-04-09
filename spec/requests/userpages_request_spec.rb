RSpec.describe "Userpage", type: :request do
  let!(:user) { create(:user, profile: "aaaaaaa", sex: 0) }
  let!(:second_user) { create(:second_user, profile: "bbbbbbb") }
  let!(:third_user) { create(:third_user) }
  let!(:great_review) { create(:great_review) }
  let!(:relationship) { create(:relationship) }
  let!(:room) { create(:room) }
  let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
  let!(:entry2) { create(:entry, user_id: second_user.id, room_id: room.id) }

  describe "#show" do
    context "ログインしている場合" do
      context "ユーザーが存在する場合" do
        context "自分のプロフィールページの場合" do
          before do
            login_as(user)
            get userpage_path user.id
          end

          it '正常なレスポンスが返ってくること' do
            expect(response).to be_successful
          end

          it '200レスポンスが返ってくること' do
            expect(response).to have_http_status(200)
          end

          it '正しいプロフィールを取得すること' do
            expect(response.body).to include user.username
            expect(response.body).to include user.profile
          end
        end

        context "他人のプロフィールページの場合" do
          context "DMをやり取りしたことのあるユーザーの場合" do
            before do
              login_as(user)
              get userpage_path second_user.id
            end

            it '正常なレスポンスが返ってくること' do
              expect(response).to be_successful
            end

            it '200レスポンスが返ってくること' do
              expect(response).to have_http_status(200)
            end

            it '正しいプロフィールや投稿を取得すること' do
              expect(response.body).to include second_user.username
              expect(response.body).to include second_user.profile
            end

            it 'DMページへのリンクが表示されること' do
              expect(response.body).to include "DMへ"
            end
          end

          context "DMをやり取りしたことのないユーザーの場合" do
            before do
              login_as(user)
              get userpage_path third_user.id
            end

            it 'DM作成するためのボタンが表示されること' do
              expect(response.body).to include "DMを送る"
            end
          end
        end
      end

      context "ユーザーが存在しない場合" do
        before do
          login_as(user)
          get userpage_path(302)
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        get userpage_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#avatar_destroy" do
    context "ログインしている場合" do
      context "ログインしているユーザーであるの場合" do
        before do
          login_as(user)
        end

        it '302レスポンスが返ってくること' do
          delete userpage_path user.id
          expect(response).to have_http_status(302)
        end

        it 'プロフィールページにリダイレクトすること' do
          delete userpage_path user.id
          expect(response).to redirect_to userpage_path
        end
      end

      context "ログインしていないユーザー場合" do
        before do
          login_as(user)
        end

        it '302レスポンスが返ってくること' do
          delete userpage_path second_user.id
          expect(response).to have_http_status(302)
        end

        it 'ルートページにリダイレクトすること' do
          delete userpage_path second_user.id
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        delete userpage_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#following" do
    context "ログインしている場合" do
      context "ユーザーが存在する場合" do
        before do
          login_as(user)
          get following_user_path user.id
        end

        it '正常なレスポンスが返ってくること' do
          expect(response).to be_successful
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '正しいプロフィールとフォローしているユーザーを表示すること' do
          expect(response.body).to include "Following"
          expect(response.body).to include second_user.username
        end
      end

      context "ユーザーが存在しない場合" do
        before do
          login_as(user)
          get following_user_path 100
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        get following_user_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#followers" do
    context "ログインしている場合" do
      context "ユーザーが存在する場合" do
        before do
          login_as(second_user)
          get followers_user_path second_user.id
        end

        it '正常なレスポンスが返ってくること' do
          expect(response).to be_successful
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '正しいプロフィールとフォローしているユーザーを表示すること' do
          expect(response.body).to include user.username
          expect(response.body).to include "Followers"
        end
      end

      context "ユーザーが存在しない場合" do
        before do
          login_as(second_user)
          get followers_user_path 100
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "未ログインの場合" do
      it 'ログインページにリダイレクトされること' do
        get followers_user_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
