require 'rails_helper'

RSpec.describe 'New Viewing Party Page', type: :feature do
  before(:each) do
    User.delete_all

    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)

    @movie = MovieFacade.new(550).find_movie

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

    visit new_movie_viewing_party_path(@movie.id)
  end

  describe 'new viewing party form', :vcr do
    it 'displays a subheader' do
      expect(page).to have_content("Create a Movie Party for #{@movie.title}")
    end

    it 'displays a Discover Page button' do
      expect(page).to have_button('Discover Page')

      click_button 'Discover Page'

      expect(current_path).to eq(discover_index_path)
    end

    it 'displays a form to create a new viewing party' do
      expect(page).to have_content('Viewing Party Details')
      expect(page).to have_content("Movie Title: #{@movie.title}")

      expect(page).to have_content('Duration of party')
      expect(page).to have_field(:duration)

      expect(page).to have_content('Day')
      expect(page).to have_field(:date)

      expect(page).to have_content('Start time')
      expect(page).to have_field(:start_time)

      expect(page).to have_content('Invite Other Users')
      expect(page).to have_unchecked_field("user_#{@user2.id}")
      expect(page).to have_content(@user2.user_name)
      expect(page).to have_unchecked_field("user_#{@user3.id}")
      expect(page).to have_content(@user3.user_name)

      expect(page).to have_button('Create Party')
    end

    it 'creates Partygoers when the form is submitted' do
      fill_in :duration, with: 120
      fill_in :date, with: '2023-11-11'
      fill_in :start_time, with: '12:00'
      check @user2.user_name
      click_button 'Create Party'

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content('Your party has been created!')
      expect(page).to have_content(@movie.title)
      expect(page).to have_content('November 11, 2023')
      expect(page).to have_content('12:00 PM')
      expect(page).to have_content(@user1.user_name)
      expect(page).to have_content(@user2.user_name)

      # visit user2's dashboard to view the invited party
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)
      visit dashboard_path

      expect(page).to have_content(@movie.title)
      expect(page).to have_content('November 11, 2023')
      expect(page).to have_content('12:00 PM')
      expect(page).to have_content(@user1.user_name)
      expect(page).to have_content(@user2.user_name)
    end

    it 'displays an alert if not all fields are filled' do
      check @user2.user_name
      click_button 'Create Party'

      expect(current_path).to eq(new_movie_viewing_party_path(@movie.id))
      expect(page).to have_content('Please fill in all fields.')
    end
  end
end
