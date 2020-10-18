module LoginModule
  def login(user)
    visit login_path
    fill_in 'Email', with: user.Email
    fill_in 'Password', with: 'password'
    click_button 'Login'
  end
end