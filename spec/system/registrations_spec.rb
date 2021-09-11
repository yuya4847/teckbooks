require 'rails_helper'
RSpec.describe "Registrations", type: :system do
  describe '#create' do
    let(:user) { build(:user) }

    it '新規ユーザー画面の要素検証すること' do
      visit '/users/sign_up'
      expect(page).to have_selector 'span', text: '※必須', count: 4
      expect(page).to have_selector 'label', text: 'ユーザー名'
      expect(page).to have_selector 'label', text: 'メールアドレス'
      expect(page).to have_selector 'label', text: 'プロフィール'
      expect(page).to have_selector 'label', text: '性別'
      expect(page).to have_selector 'label', text: 'パスワード'
      expect(page).to have_selector 'label', text: 'パスワード(確認用）'
      expect(page).to have_selector 'input', class: 'username_form'
      expect(page).to have_selector 'input', class: 'email_form'
      expect(page).to have_selector 'textarea', class: 'profile_area'
      expect(page).to have_selector 'input', class: 'sex_man_form'
      expect(page).to have_selector 'input', class: 'sex_woman_form'
      expect(page).to have_selector 'input', class: 'password_form'
      expect(page).to have_selector 'input', class: 'password_confirmation_form'
      expect(page).to have_button 'Sign up'
      expect(page).to have_link 'ログインする'
      expect(page).to have_link 'アカウント有効化のメールが届いていない方'
    end

    it '各入力欄に適切な値が入力されていない新規ユーザーを許可しないこと' do
      visit '/users/sign_up'
      click_button 'Sign up'
      within('.error_message') do
        expect(page).to have_content '以下のエラーにより、保存されませんでした。'
      end
      within('.error_messages') do
        expect(page).to have_content 'ユーザー名を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'メールアドレスは不正な値です'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
      end
    end

    it 'username,email,passwordが全て正しい場合、新規ユーザーが可能であること' do
      visit '/users/sign_up'
      fill_in 'user_username', with: user.username
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password_confirmation
      click_button 'Sign up'
      within('.notice') do
        expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      end
    end
  end

  describe '#edit' do
    let(:user) { create(:user) }

    it 'プロフィール編集画面の要素検証すること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/users/edit'
      expect(page).to have_selector 'label', text: 'ユーザー名'
      expect(page).to have_selector 'label', text: 'メールアドレス'
      expect(page).to have_selector 'label', text: 'プロフィール'
      expect(page).to have_selector 'label', text: 'Avatar'
      expect(page).to have_selector 'label', text: 'パスワード'
      expect(page).to have_selector 'label', text: 'パスワード(確認用）'
      expect(page).to have_selector 'input', class: 'username_form'
      expect(page).to have_selector 'input', class: 'email_form'
      expect(page).to have_selector 'textarea', class: 'profile_area'
      expect(page).to have_selector 'input', class: 'avatar_select'
      expect(page).to have_selector 'input', class: 'password_form'
      expect(page).to have_selector 'input', class: 'password_confirmation_form'
      expect(page).to have_button '編集完了'
      expect(page).to have_button 'アカウントを削除したい方'
      expect(page).to have_link '戻る'
    end

    it '適切なusernameだけ入力し編集完了できること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/users/edit'
      fill_in 'user_username', with: "edit_user"
      fill_in 'user_password', with: ""
      fill_in 'user_password_confirmation', with: ""
      click_button '編集完了'
      expect(current_path).to eq userpage_path(user)
      expect(page).not_to have_content 'ようこそ'
      within('.notice') do
        expect(page).to have_content 'アカウント情報を変更しました。'
      end
    end

    it 'username,passwordを適切な値が入力され編集完了できること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/users/edit'
      fill_in 'user_username', with: "edit_user"
      fill_in 'user_password', with: "edit_password"
      fill_in 'user_password_confirmation', with: "edit_password"
      click_button '編集完了'
      expect(current_path).to eq new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: "edit_password"
      click_button 'ログイン'
      expect(current_path).to eq userpage_path(user)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      expect(page).to have_content "edit_user"
    end

    it 'username,emailを適切な値が入力され編集完了できること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/users/edit'
      fill_in 'user_username', with: "edit_user"
      fill_in 'user_email', with: "edituser@example.com"
      click_button '編集完了'
      expect(current_path).to eq userpage_path(user)
      expect(page).not_to have_content 'ようこそ'
      within('.notice') do
        expect(page).to have_content 'アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。'
      end
    end
  end

  describe '#destroy' do
    let(:user) { create(:user) }

    it 'ユーザーのアカウントを停止できること' do
      log_in_as(user.email, user.password)
      within('.notice') do
        expect(page).to have_content 'ログインしました'
      end
      visit '/users/edit'
      click_button 'アカウントを削除したい方'
      expect(current_path).to eq root_path
      expect(page).to have_content 'ようこそ'
      within('.notice') do
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
      end
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'ログイン'
      within('.alert') do
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe 'accountの有効化' do
    let(:user) { build(:user) }

    it 'アカウント有効化メール再送信画面の要素検証をすること' do
      visit '/users/confirmation/new.user'
      expect(page).to have_content 'アカウント有効化のメールを再送信'
      expect(page).to have_selector 'label', text: 'メールアドレス'
      expect(page).to have_selector 'input', class: 'account_mail'
      expect(page).to have_button 'メールを送る'
      expect(page).to have_link 'ログインする'
      expect(page).to have_link 'サインアップする'
      expect(page).to have_link 'パスワードを忘れた方'
    end

    it 'フォームが空だと送信できないこと' do
      user.save
      visit '/users/confirmation/new.user'
      fill_in 'user_email', with: "aaaaaaaa@aa.aa"
      click_button 'メールを送る'
      expect(page).to have_content 'メールアドレスは見つかりませんでした。'
    end

    context 'アカウントが有効化できているとき' do
      it 'アカウント有効化のアカウント有効化が再送信できないこと' do
        user.save
        visit '/users/confirmation/new.user'
        expect(page).to have_content 'アカウント有効化のメールを再送信'
        fill_in 'user_email', with: user.email
        click_button 'メールを送る'
        expect(page).to have_content '以下のエラーにより、保存されませんでした。'
        expect(page).to have_content 'メールアドレスは既に登録済みです。ログインしてください。'
      end
    end

    context 'メールが届いておらず有効化できていないとき' do
      it 'アカウント有効化のメールが再送信できること' do
        visit '/users/sign_up'
        fill_in 'user_username', with: user.username
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password_confirmation
        click_button 'Sign up'
        within('.notice') do
          expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
        end
        visit '/users/confirmation/new.user'
        expect(page).to have_content 'アカウント有効化のメールを再送信'
        fill_in 'user_email', with: user.email
        click_button 'メールを送る'
        expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡します。'
      end
    end

    context 'ユーザーを作っておらず有効化できていないとき' do
      it 'アカウント有効化のメールが送信できないこと' do
        visit '/users/confirmation/new.user'
        expect(page).to have_content 'アカウント有効化のメールを再送信'
        fill_in 'user_email', with: user.email
        click_button 'メールを送る'
        expect(page).to have_content '以下のエラーにより、保存されませんでした。'
        expect(page).to have_content 'メールアドレスは見つかりませんでした。'
      end
    end
  end

  describe 'パスワードの変更' do
    let(:user) { create(:user) }

    it 'パスワード変更画面の要素検証すること' do
      visit '/users/password/new'
      expect(page).to have_content 'パスワードを変更'
      expect(page).to have_selector 'label', text: 'メールアドレス'
      expect(page).to have_selector 'input', class: 'change_password'
      expect(page).to have_button 'メールを送る'
      expect(page).to have_link 'ログインする'
      expect(page).to have_link 'サインアップする'
      expect(page).to have_link 'アカウント有効化のメールが届いていない方'
    end

    it '不適切なメールアドレスだと送信できないこと' do
      visit '/users/password/new'
      fill_in 'user_email', with: "aaaaaaaa@aa.aa"
      click_button 'メールを送る'
      expect(page).to have_content 'メールアドレスは見つかりませんでした。'
    end

    it 'パスワードを忘れたときに変更できること' do
      visit '/users/sign_in'
      click_link "パスワードを忘れた方"
      expect(page).to have_content 'パスワードを変更'
      have_link "ログインする"
      have_link "サインアップする"
      have_link "アカウント有効化のメールが届いていない方"
      fill_in 'user_email', with: user.email
      click_button 'メールを送る'
      expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
    end
  end

  describe 'プロフィールページの表示' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:good_review) { create(:good_review) }
    let!(:normal_review) { create(:normal_review) }
    let!(:relationship) { create(:relationship) }

    context "ユーザーが存在しない場合" do
      it '存在しないプロフィールは閲覧できないこと' do
        log_in_as(user.email, user.password)
        within('.notice') do
          expect(page).to have_content 'ログインしました'
        end
        visit userpage_path(3)
        expect(current_path).to eq root_path
        within('.alert') do
          expect(page).to have_content 'ユーザーは存在しません。'
        end
      end
    end

    context "ユーザーが存在する場合" do
      it 'アバター変更, プロフィールの変更のリンクがないこと' do
        log_in_as(user.email, user.password)
        within('.notice') do
          expect(page).to have_content 'ログインしました'
        end
        expect(current_path).to eq userpage_path(user)
        expect(page).to have_content user.username
        expect(page).to have_content user.profile
        expect(page).to have_content "男"
        expect(page).to have_link "アバターを変更する"
        expect(page).to have_link "プロフィール変更"
        expect(page).to have_link '編集する'
        expect(page).to have_link '削除する'
        expect(page).to have_link '1 following'
        expect(page).to have_link '0 followers'
        visit userpage_path(second_user)
        expect(page).to have_no_link "アバターを変更する"
        expect(page).to have_no_link "プロフィール変更"
        expect(page).to have_no_link '編集する'
        expect(page).to have_no_link '削除する'
      end
    end
  end
end
