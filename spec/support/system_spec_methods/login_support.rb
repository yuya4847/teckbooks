module LoginSupport
  def log_in_as(user_email, user_password)
    visit '/users/sign_in'
    fill_in 'user_email', with: user_email
    fill_in 'user_password', with: user_password
    click_button 'ログイン'
  end
end
