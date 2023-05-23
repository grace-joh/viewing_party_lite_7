require 'rails_helper'

RSpec.describe 'user registration page', type: :feature do
  before(:each) do
    visit '/register'
  end

  describe 'when I visit the registration page' do
    it 'I should see a form with a text field for name and email and a button to register' do
      expect(page).to have_content('Register a New User')
      expect(page).to have_field('User name')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Password confirmation')
      expect(page).to have_button('Create New User')
    end

    it 'when I fill out the email with one that already exists I should see an error message' do
      create(:user, email: 'already_here@hotmail.edu')

      fill_in 'User name', with: 'Test User'
      fill_in 'Email', with: 'already_here@hotmail.edu'
      fill_in 'Password', with: 'blah'
      fill_in 'Password confirmation', with: 'blah'
      click_button 'Create New User'

      expect(page).to have_content('Email has already been taken')
    end

    it 'when I fill out the email with a new one I be redirected to the user dashboard for that user' do

      fill_in 'User name', with: 'Test User'
      fill_in 'Email', with: 'new_email@hotmail.edu'
      fill_in 'Password', with: 'secret123'
      fill_in 'Password confirmation', with: 'secret123'
      click_button 'Create New User'

      expect(current_path).to eq(dashboard_path)

      visit '/'

      expect(page).to have_content(User.last.email)
    end

    it 'when password and password confirmation do not match, I am taken back to the register page with an error' do
      fill_in 'User name', with: 'Test User'
      fill_in 'Email', with: 'new_email@hotmail.edu'
      fill_in 'Password', with: 'secret123'
      fill_in 'Password confirmation', with: 'secret12345'
      click_button 'Create New User'

      expect(current_path).to eq('/register')
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
