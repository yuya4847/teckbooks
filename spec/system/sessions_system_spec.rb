require 'rails_helper'
RSpec.describe "Sessions", type: :system do
  describe 'ログイン・ログアウト機能の検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:unconfirmed_user) { create(:unconfirmed_user, id: 2) }
    let!(:recent_review) { create(:recent_review, id: 1) }
    let!(:good_review) { create(:good_review, id: 2) }
    let!(:great_review) { create(:great_review, id: 3) }

    it 'ログインページの要素検証すること' do
      visit '/users/sign_in'
      within('#login-email-right-keyup') do
        expect(page).to have_selector 'input', class: 'email_form'
      end
      within('#login-pass-right-keyup') do
        expect(page).to have_selector 'input', class: 'password_form'
      end
      within('.forget-password') do
        expect(page).to have_link 'パスワードを忘れた方'
      end
      within('.account') do
        expect(page).to have_link 'アカウント有効化のメールが届いていない方'
      end
      within('.login-field') do
        expect(page).to have_selector 'input', class: 'login-btn'
      end
    end

    it 'email,passwordの両方が正しい場合、ログインが可能であること' do
      # email,password共に未入力
      log_in_as(nil, nil)
      within('.alert') do
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
      # 誤ったemail
      log_in_as('invalidemail@sample.com', user.password)
      within('.alert') do
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
      # 誤ったpassword
      log_in_as(user.email, 'invalid_password')
      within('.alert') do
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
      # 有効なemailとpasswordだがアカウントが有効でない場合
      log_in_as(unconfirmed_user.email, unconfirmed_user.password)
      within('.alert') do
        expect(page).to have_content 'メールアドレスの本人確認が必要です。'
      end
      # 有効なemailとpassword
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
    end

    it 'ログアウトが可能であること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      click_link 'ログアウト'
      within('.notice') do
        expect(page).to have_content 'ログアウトしました。'
      end
    end
  end

  describe 'ログイン状態でページ遷移が変わること' do
    let!(:user) { create(:user, id: 1) }
    let!(:unconfirmed_user) { create(:unconfirmed_user, id: 2) }
    let!(:recent_review) { create(:recent_review, id: 1) }
    let!(:good_review) { create(:good_review, id: 2) }
    let!(:great_review) { create(:great_review, id: 3) }

    context '未ログイン状態の場合' do
      it '未ログインユーザー用のページが表示されること' do
        visit root_path
        visit '/users/edit'
        within('.alert') do
          expect(page).to have_content 'アカウント登録もしくはログインしてください。'
        end
      end
    end

    context 'ログイン状態の場合' do
      it 'ログイン、新規登録ページにアクセスできないこと' do
        log_in_as(user.email, user.password)
        within('.notice') do
          expect(page).to have_content 'ログインしました'
        end
        expect(current_path).to eq userpage_path(user)
        visit root_path
        expect(current_path).to eq root_path
        visit '/users/edit'
        expect(current_path).to eq edit_user_registration_path
        visit '/users/sign_in'
        expect(current_path).to eq userpage_path(user)
        within('.alert') do
          expect(page).to have_content 'すでにログインしています。'
        end
        visit '/users/sign_up'
        expect(current_path).to eq userpage_path(user)
        within('.alert') do
          expect(page).to have_content 'すでにログインしています。'
        end
      end
    end
  end
end
