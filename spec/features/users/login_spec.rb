require 'rails_helper'

RSpec.describe 'Log in Sessions' do
  it 'can log in with valid credentials' do
    user = create(:user)

    visit root_path

    click_on 'Log In'

    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on 'Log In'

    expect(current_path).to eq(dashboard_path)

    expect(page).to have_content("#{user.user_name}'s Dashboard")

    visit root_path

    expect(page).to have_link('Log Out')
    expect(page).to_not have_link('Create User')
    expect(page).to_not have_link('Log In')
  end

  it 'cannot log in with bad credentials' do
    user = create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: 'wrongpassword'

    click_on 'Log In'

    expect(current_path).to eq(login_path)

    expect(page).to have_content('Sorry, your credentials are bad.')

    visit root_path

    expect(page).to_not have_link('Log Out')
    expect(page).to have_link('Create User')
    expect(page).to have_link('Log In')
  end

  it 'can log out a user' do
    user = create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on 'Log In'

    visit root_path

    click_link('Log Out')

    expect(current_path).to eq(root_path)
    expect(page).to_not have_link('Log Out')
    expect(page).to have_link('Create User')
    expect(page).to have_link('Log In')
  end
end
