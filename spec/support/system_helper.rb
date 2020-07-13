module SystemHelper
  def login_as(login_user)
    # user = create(:user)
    visit login_path
    fill_in 'Email', with: login_user.email
    fill_in 'Password', with: 'password'
    click_button 'Login'
  end
end