require 'rails_helper'
RSpec.describe "Registrations", type: :system do
  describe '新規ユーザーの作成' do
    let!(:user) { build(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:recent_review) { create(:recent_review) }
    let!(:good_review) { create(:good_review) }
    let!(:great_review) { create(:great_review) }

    it '新規ユーザー画面の要素検証すること' do
      visit '/users/sign_up'
      within('#signup-username-right-keyup') do
        expect(page).to have_selector 'input', id: 'user_username'
      end
      within('#signup-email-right-keyup') do
        expect(page).to have_selector 'input', id: 'user_email'
      end
      within('#signup-profile-right-keyup') do
        expect(page).to have_selector 'textarea', id: 'user_profile'
      end
      within('.signup-sex-form') do
        expect(page).to have_selector 'input', id: 'user_sex_man'
        expect(page).to have_selector 'input', id: 'user_sex_woman'
      end
      within('#signup-pass-right-keyup') do
        expect(page).to have_selector 'input', id: 'user_password'
      end
      within('#signup-conf-pass-right-keyup') do
        expect(page).to have_selector 'input', id: 'user_password_confirmation'
      end
      within('.signup-btn-div') do
        expect(page).to have_selector("input[value$='新規登録']")
      end
    end

    it '各入力欄に適切な値が入力されていない新規ユーザーを許可しないこと' do
      visit '/users/sign_up'
      click_button '新規登録'
      within('.sign-up-error-messages') do
        expect(page).to have_content '・ ユーザー名を入力してください'
        expect(page).to have_content '・ メールアドレスを入力してください'
        expect(page).to have_content '・ メールアドレスは不正な値です'
        expect(page).to have_content '・ パスワードを入力してください'
        expect(page).to have_content '・ パスワードは6文字以上で入力してください'
      end
      visit '/users/sign_up'
      fill_in 'user_username', with: 'a' * 21
      fill_in 'user_email', with: "aaauser1@yyyy.com" + 'a' * 250
      fill_in 'user_profile', with: 'a' * 256
      fill_in 'user_password', with: 'a' * 6
      fill_in 'user_password_confirmation', with: 'b' * 6
      click_button '新規登録'
      within('.sign-up-error-messages') do
        expect(page).to have_content '・ ユーザー名は20文字以内で入力してください'
        expect(page).to have_content '・ メールアドレスは255文字以内で入力してください'
        expect(page).to have_content '・ プロフィールは255文字以内で入力してください'
        expect(page).to have_content '・ パスワード(確認用）とパスワードの入力が一致しません'
      end
    end

    it 'username,email,passwordが全て正しい場合、新規ユーザーが可能であること' do
      visit '/users/sign_up'
      fill_in 'user_username', with: user.username
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password_confirmation
      click_button '新規登録'
      within('.notice') do
        expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      end
    end
  end

  describe 'ユーザー情報の編集' do
    let!(:user) { create(:user) }
    let!(:recent_review) { create(:recent_review) }
    let!(:good_review) { create(:good_review) }
    let!(:great_review) { create(:great_review) }

    it 'プロフィール編集画面の要素検証すること' do
      log_in_as(user.email, user.password)
      visit '/users/edit'
      within('.profile-edit-field-username') do
        expect(page).to have_selector 'input', id: 'user_username'
      end
      within('.profile-edit-field-email') do
        expect(page).to have_selector 'input', id: 'user_email'
        expect(page).to have_selector 'div', text: 'メールアドレス'
      end
      within('.profile-edit-field-profile') do
        expect(page).to have_selector 'textarea', id: 'user_profile'
        expect(page).to have_selector 'div', text: 'プロフィール'
      end
      within('.profile-edit-field-password') do
        expect(page).to have_selector 'input', id: 'user_password'
        expect(page).to have_selector 'div', text: 'パスワード'
      end
      within('.profile-edit-field-password-conf') do
        expect(page).to have_selector 'input', id: 'user_password_confirmation'
        expect(page).to have_selector 'div', text: 'パスワード(確認)'
      end
      within('.profile-edit-btn-div') do
        expect(page).to have_selector("input[value$='編集完了']")
      end
      within('.delete-registration') do
        expect(page).to have_selector 'a', text: '退会する'
      end
      within('.icon-image-selects') do
        expect(page).to have_selector("img[class$='icon-image-class']")
        expect(page).to have_selector 'label', text: 'アイコン変更'
        expect(page).to have_selector("input[id$='user_avatar']")
      end
    end

    it '適切なusernameだけ入力し編集完了できること' do
      log_in_as(user.email, user.password)
      visit '/users/edit'
      fill_in 'user_username', with: "edit_user"
      fill_in 'user_password', with: ""
      fill_in 'user_password_confirmation', with: ""
      click_button '編集完了'
      expect(current_path).to eq userpage_path(user)
      within('.notice') do
        expect(page).to have_content 'アカウント情報を変更しました。'
      end
    end

    it 'username,passwordを適切な値が入力され編集完了できること' do
      log_in_as(user.email, user.password)
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
    end

    it 'username,emailを適切な値が入力され編集完了できること' do
      log_in_as(user.email, user.password)
      visit '/users/edit'
      fill_in 'user_username', with: "edit_user"
      fill_in 'user_email', with: "edituser@example.com"
      click_button '編集完了'
      expect(current_path).to eq userpage_path(user)
      within('.notice') do
        expect(page).to have_content 'アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。'
      end
    end

    it 'アバターの変更ができること' do
      log_in_as(user.email, user.password)
      visit '/users/edit'
      attach_file('user[avatar]', "#{Rails.root}/spec/factories/images/test_avatar.jpg")
      click_button '編集完了'
      expect(current_path).to eq userpage_path(user)
      within('.mypage-profile-title') do
        expect(page).to have_selector("img[src$='/uploads_test/user/avatar/1/test_avatar.jpg']")
      end
    end
  end

  describe 'ユーザーのアカウント削除' do
    let!(:admin_user) { create(:third_user) }
    let!(:sample_user) { create(:second_user) }
    let!(:user) { create(:user) }
    let!(:recent_review) { create(:recent_review) }
    let!(:good_review) { create(:good_review) }
    let!(:great_review) { create(:great_review) }

    it 'ユーザーのアカウントを停止できること' do
      log_in_as(user.email, user.password)
      visit '/users/edit'
      find('.delete-registration-link').click
      expect(current_path).to eq root_path
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
    let!(:user) { build(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:recent_review) { create(:recent_review) }
    let!(:good_review) { create(:good_review) }
    let!(:great_review) { create(:great_review) }

    it 'アカウント有効化メール再送信画面の要素検証をすること' do
      visit '/users/confirmation/new.user'
      expect(page).to have_selector 'div', text: 'パスワード再設定'
      within('#confirmation-email-right-keyup') do
        expect(page).to have_selector 'input', id: 'user_email'
      end
      within('.account-pass-change-btn-div') do
        expect(page).to have_selector("input[value$='メールを送る']")
      end
      within('.account-password-change-other-link-div') do
        expect(page).to have_link 'パスワードを忘れた方'
      end
    end

    it 'フォームが空だと送信できないこと' do
      user.save
      visit '/users/confirmation/new.user'
      fill_in 'user_email', with: ""
      find('.account-pass-change-btn').click
      expect(page).to have_selector 'div', class: 'password-change-validation', text: '・メールアドレスを入力してください'
    end

    context 'アカウントが有効化できているとき' do
      it 'アカウント有効化のアカウント有効化が再送信できないこと' do
        user.save
        visit '/users/confirmation/new.user'
        fill_in 'user_email', with: user.email
        find('.account-pass-change-btn').click
        expect(page).to have_selector 'div', class: 'password-change-validation', text: '・メールアドレスは既に登録済みです。ログインしてください'
      end
    end

    context 'メールが届いておらず有効化できていないとき' do
      it 'アカウント有効化のメールが再送信できること' do
        visit '/users/sign_up'
        fill_in 'user_username', with: user.username
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password_confirmation
        click_button '新規登録'
        within('.notice') do
          expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
        end
        visit '/users/confirmation/new.user'
        fill_in 'user_email', with: user.email
        find('.account-pass-change-btn').click
        within('.notice') do
          expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡します。'
        end
      end
    end

    context 'ユーザーを作っておらず有効化できていないとき' do
      it 'アカウント有効化のメールが送信できないこと' do
        visit '/users/confirmation/new.user'
        fill_in 'user_email', with: user.email
        find('.account-pass-change-btn').click
        expect(page).to have_selector 'div', class: 'password-change-validation', text: '・メールアドレスは見つかりませんでした'
      end
    end
  end

  describe 'パスワードの変更' do
    let(:user) { create(:user) }

    it 'パスワード変更画面の要素検証すること' do
      visit '/users/password/new'
      expect(page).to have_selector 'div', text: 'パスワード変更', class: 'change-pass-title'
      within('#pass-edit-email-right-keyup') do
        expect(page).to have_selector 'input', id: 'pass-new-email-right-keyup'
      end
      within('.password-change-btn-div') do
        expect(page).to have_selector("input[value$='メールを送る']")
      end
      within('.password-change-other-link-div') do
        expect(page).to have_link 'アカウント有効化のメールが届いていない方'
      end
    end

    it '不適切なメールアドレスだと送信できないこと' do
      visit '/users/password/new'
      fill_in 'pass-new-email-right-keyup', with: "aaaaaaaa@aa.aa"
      click_button 'メールを送る'
      expect(page).to have_selector 'div', class: 'password-change-validation', text: '・メールアドレスは見つかりませんでした。'
    end
  end

  describe 'プロフィールページの表示' do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:second_user) }
    let!(:third_user) { create(:third_user) }
    let!(:recent_review) { create(:recent_review) }
    let!(:good_review) { create(:good_review) }
    let!(:great_review) { create(:great_review) }
    let!(:relationship) { create(:relationship) }
    let!(:room) { create(:room) }
    let!(:entry1) { create(:entry, user_id: user.id, room_id: room.id) }
    let!(:entry2) { create(:entry, user_id: third_user.id, room_id: room.id) }

    context "ユーザーが存在しない場合" do
      it '存在しないプロフィールは閲覧できないこと' do
        log_in_as(user.email, user.password)
        visit userpage_path(4)
        expect(current_path).to eq root_path
        within('.alert') do
          expect(page).to have_content 'ユーザーは存在しません。'
        end
      end
    end

    context "ユーザーが存在する場合" do
      it 'ユーザによって適切なプロフィールが表示されること' do
        log_in_as(user.email, user.password)
        expect(current_path).to eq userpage_path(user)
        within('.mypage-profile-title') do
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_selector 'svg', class: "sex-select-icon"
          expect(page).to have_content user.username
          expect(page).to have_link '1 following'
          expect(page).to have_link '0 followers'
        end
        expect(page).to have_selector 'div', class: "mypage-profile-profile", text: "#{user.profile}"
        within('.mypage-profile-dm-btn') do
          expect(page).to have_selector 'div', text: "DM"
        end
        within('.profile-reviews') do
          expect(page).to have_selector 'div', text: "投稿したレビューを見る"
        end
        within('.mypage-profile-statuses') do
          expect(page).to have_selector 'div', text: "STATUS"
          expect(page).to have_selector 'div', text: "公開"
          expect(page).to have_selector 'div', text: "権限ユーザー"
        end
        within('.mypage-profile-edit-btn') do
          expect(page).to have_selector 'div', text: "編集"
        end
        visit '/userpages/2'
        expect(current_path).to eq userpage_path(second_user)
        within('.mypage-profile-title') do
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_selector 'svg', class: "sex-select-icon"
          expect(page).to have_content second_user.username
          expect(page).to have_link '0 following'
          expect(page).to have_link '1 followers'
        end
        expect(page).to have_selector 'div', class: "mypage-profile-profile", text: "#{second_user.profile}"
        within('.new_room') do
          expect(page).to have_selector 'span', text: "DMを送る"
        end
        within('.profile-reviews') do
          expect(page).to have_selector 'div', text: "投稿したレビューを見る"
        end
        within('.mypage-profile-statuses') do
          expect(page).to have_selector 'div', text: "STATUS"
          expect(page).to have_selector 'div', text: "公開"
          expect(page).to have_selector 'div', text: "サンプルユーザー"
        end
        within('.mypage-follow-btn') do
          expect(page).to have_selector 'div', text: "following"
        end
        visit '/userpages/3'
        expect(current_path).to eq userpage_path(third_user)
        within('.mypage-profile-title') do
          expect(page).to have_selector("img[src$='/uploads/user/avatar/default.png']")
          expect(page).to have_selector 'svg', class: "sex-select-icon"
          expect(page).to have_content third_user.username
          expect(page).to have_link '0 following'
          expect(page).to have_link '0 followers'
        end
        expect(page).to have_selector 'div', class: "mypage-profile-profile", text: "#{third_user.profile}"
        within('.to-dm') do
          expect(page).to have_selector 'div', text: "DMへ"
        end
        within('.profile-reviews') do
          expect(page).to have_selector 'div', text: "投稿したレビューを見る"
        end
        within('.mypage-profile-statuses') do
          expect(page).to have_selector 'div', text: "STATUS"
          expect(page).to have_selector 'div', text: "公開"
          expect(page).to have_selector 'div', text: "一般ユーザー"
        end
        within('.mypage-follow-btn') do
          expect(page).to have_selector 'div', text: "follow"
        end
      end
    end
  end
end
