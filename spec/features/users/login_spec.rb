require 'rails_helper'

RSpec.describe 'Logging In' do
  it 'can log in with valid credentials' do
    user = create(:user)

    visit root_path

    click_on 'I already have an account'

    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on 'Log In'

    expect(current_path).to eq(user_path(user))

    expect(page).to have_content("#{user.user_name}'s Dashboard")
  end

  it 'cannot log in with bad credentials' do
    user = create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: 'wrongpassword'

    click_on 'Log In'

    expect(current_path).to eq(login_path)

    expect(page).to have_content('Sorry, your credentials are bad.')
  end
end
