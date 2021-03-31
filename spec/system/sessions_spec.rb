require 'rails_helper'
RSpec.describe "Sessions", type: :system do
  before do
    @user = create(:user)
    @unconfirmed_user = create(:unconfirmed_user)
  end

  it 'ログインページの要素検証すること' do
    visit '/users/sign_in'
    expect(page).to have_selector 'label', text: 'メールアドレス'
    expect(page).to have_selector 'label', text: 'パスワード'
    expect(page).to have_button 'ログイン'
    expect(page).to have_selector 'input', class: 'email_form'
    expect(page).to have_selector 'input', class: 'password_form'
    expect(page).to have_link 'サインアップする'
    expect(page).to have_link 'パスワードを忘れた方'
    expect(page).to have_link 'アカウント有効化のメールが届いていない方'
  end

  it 'email,passwordの両方が正しい場合、ログインが可能であること' do
    visit '/users/sign_in'
    # email,password共に未入力
    click_button 'ログイン'
    within('.alert') do
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
    end
    # 誤ったemail
    fill_in 'user_email', with: 'invalidemail@sample.com'
    fill_in 'user_password', with: @user.password
    click_button 'ログイン'
    within('.alert') do
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
    end
    # 誤ったpassword
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: 'invalid_password'
    click_button 'ログイン'
    within('.alert') do
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
    end
    # 有効なemailとpasswordだがアカウントが有効でない場合
    fill_in 'user_email', with: @unconfirmed_user.email
    fill_in 'user_password', with: @unconfirmed_user.password
    click_button 'ログイン'
    within('.alert') do
      expect(page).to have_content 'メールアドレスの本人確認が必要です。'
    end
    # 有効なemailとpassword
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'ログイン'
    within('.notice') do
      expect(page).to have_content 'ログインしました'
    end
  end

  it 'ログイン前後ヘッダーのリンクが違うこと' do
    visit '/users/sign_in'
    expect(page).to have_link 'ホーム'
    expect(page).to have_link 'サインアップ'
    expect(page).to have_link 'ログイン'
    expect(page).not_to have_link 'プロフィール変更'
    expect(page).not_to have_link 'ログアウト'

    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'ログイン'
    within('.notice') do
      expect(page).to have_content 'ログインしました'
    end
    expect(page).to have_link 'ホーム'
    expect(page).not_to have_link 'サインアップ'
    expect(page).not_to have_link 'ログイン'
    expect(page).to have_link 'プロフィール変更'
    expect(page).to have_link 'ログアウト'
  end

  it 'ログアウトが可能であること' do
    visit '/users/sign_in'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'ログイン'
    within('.notice') do
      expect(page).to have_content 'ログインしました'
    end
    click_link 'ログアウト'
    within('.notice') do
      expect(page).to have_content 'ログアウトしました。'
    end
  end

  describe 'ログイン状態でページ遷移が変わること' do
    context '未ログイン状態の場合' do
      it '未ログインユーザー用のページが表示されること' do
        visit root_path
        expect(page).to have_content 'ようこそ'

        visit '/users/edit'
        expect(page).not_to have_content 'Userを編集する'
        expect(page).to have_content 'ログイン画面'
        within('.alert') do
          expect(page).to have_content 'アカウント登録もしくはログインしてください。'
        end
      end
    end

    context 'ログイン状態の場合' do
      it 'ログイン、新規登録ページにアクセスできないこと' do
        visit '/users/sign_in'
        fill_in 'user_email', with: @user.email
        fill_in 'user_password', with: @user.password
        click_button 'ログイン'
        within('.notice') do
          expect(page).to have_content 'ログインしました'
        end

        visit root_path
        expect(current_path).to eq root_path
        expect(page).to have_content @user.username

        visit '/users/edit'
        expect(current_path).to eq edit_user_registration_path
        expect(page).to have_content 'ユーザーを編集する'

        visit '/users/sign_in'
        expect(current_path).to eq root_path
        within('.alert') do
          expect(page).to have_content 'すでにログインしています。'
        end

        visit '/users/sign_up'
        expect(current_path).to eq root_path
        within('.alert') do
          expect(page).to have_content 'すでにログインしています。'
        end
      end
    end
  end
end
