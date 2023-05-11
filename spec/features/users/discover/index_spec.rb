require 'rails_helper'

RSpec.describe 'Discover Movies Page', type: :feature do
  before(:each) do
    @user = create(:user)

    visit user_discover_index_path(@user)
  end

  describe 'top rated movies button', :vcr do
    it 'displays a button that can take you to the movie results page with top rated movies' do
      expect(page).to have_button('Find Top Rated Movies')

      click_button 'Find Top Rated Movies'

      expect(current_path).to eq(user_movies_path(@user))
    end
  end
  
  describe 'find movies form' do
    it 'displays a form to find movies by keyword' do
      expect(page).to have_field(:q)
      expect(page).to have_button('Find Movies')
    end

    it 'takes you to the movie results page when you click the find movies button', :vcr do
      fill_in :q, with: 'The Avengers'

      click_on 'Find Movies'

      expect(current_path).to eq(user_movies_path(@user))
    end

    it 'returns an error if the field is left empty', :vcr do
      click_on 'Find Movies'

      expect(page).to have_content('Please enter a movie')
      expect(current_path).to eq(user_discover_index_path(@user))
    end
  end
end