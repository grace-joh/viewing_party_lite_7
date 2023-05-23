require 'rails_helper'

RSpec.describe 'landing page', type: :feature do
  before(:each) do
    @user_1 = create(:user)
    @user_2 = create(:user)
    @user_3 = create(:user)

    visit '/'
  end

  describe 'headers' do
    it 'when I visit the root path I should see the title of the application' do
      expect(page).to have_content('Viewing Party')
    end

    it 'when I visit the root path I should see a link to go back to the landing page' do
      expect(page).to have_link('Home')

      click_link('Home')

      expect(current_path).to eq(root_path)
    end
  end

  describe 'As a visitor' do
    it 'I should see the links Create User' do
      within('#new-user') do
        expect(page).to have_link('Create User')

        click_link('Create User')

        expect(current_path).to eq(register_path)
      end
    end

    it 'I should see the links Log In' do
      expect(page).to have_link('Log In')

      click_link('Log In')

      expect(current_path).to eq(login_path)
    end

    it 'I do not see the section that lists existing users' do
      expect(page).to_not have_content('Existing Users')
      expect(page).to_not have_content(@user_1.email)
      expect(page).to_not have_content(@user_2.email)
      expect(page).to_not have_content(@user_3.email)
    end
  end

  describe 'As a registered user' do
    it 'when I visit the root path I should see a list of existing users which links to the users dashboard' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
      visit '/'

      within('#existing-users') do
        expect(page).to have_content('Existing Users')

        expect(page).to have_content(@user_1.email)
        expect(page).to have_content(@user_2.email)
        expect(page).to have_content(@user_3.email)
      end
    end
  end
end
