require 'rails_helper'

RSpec.describe 'landing page', type: :feature do
  before(:each) do
    @user_1 = create(:user)
    @user_2 = create(:user)
    @user_3 = create(:user)
    
    visit '/'
  end

  describe 'index' do
    it 'when I visit the root path I should see the title of the application' do
      expect(page).to have_content('Viewing Party')
    end

    it 'when I visit the root path I should see the links Create User and I already have an account' do
      within('#new-user') do
        expect(page).to have_link('Create User')

        click_link('Create User')

        expect(current_path).to eq(register_path)
      end
      expect(page).to have_link('I already have an account')
    end

    it 'when I visit the root path I should see a list of existing users which links to the users dashboard' do
      within('#existing-users') do
        expect(page).to have_content('Existing Users')

        expect(page).to have_link(@user_1.email)
        click_link(@user_1.email)
        expect(current_path).to eq(user_path(@user_1))
        
        visit '/'
        
        expect(page).to have_link(@user_2.email)
        click_link(@user_2.email)
        expect(current_path).to eq(user_path(@user_2))
        
        visit '/'

        expect(page).to have_link(@user_3.email)
        click_link(@user_3.email)
        expect(current_path).to eq(user_path(@user_3))
      end
    end

    it 'when I visit the root path I should see a link to go back to the landing page' do
      expect(page).to have_link('Home')

      click_link('Home')

      expect(current_path).to eq(root_path)
    end
  end
end