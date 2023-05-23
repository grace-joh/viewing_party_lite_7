require 'rails_helper'

RSpec.describe 'users dashboard show page', type: :feature do
  describe 'As a visitor' do
    it 'redirects me to the landing page' do
      visit dashboard_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You must be logged in or registered to access your dashboard')
    end
  end

  describe 'As a registered user' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @user4 = create(:user)
      @user5 = create(:user)

      MovieFacade.new(550).find_movie
      @party1 = create(:party, movie_id: 550)
      MovieFacade.new(545611).find_movie
      @party2 = create(:party, movie_id: 545611)
      @party3 = create(:party, movie_id: 545611)

      @partygoer1 = create(:partygoer, user: @user1, party: @party1, host: true)
      @partygoer2 = create(:partygoer, user: @user2, party: @party1)
      @partygoer3 = create(:partygoer, user: @user3, party: @party1)
      @partygoer4 = create(:partygoer, user: @user1, party: @party2)
      @partygoer5 = create(:partygoer, user: @user2, party: @party2, host: true)
      @partygoer6 = create(:partygoer, user: @user4, party: @party2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      visit dashboard_path
    end

    it 'displays the dashboard header', :vcr do
      expect(page).to have_content("#{@user1.user_name}'s Dashboard")
      expect(page).to_not have_content("#{@user2.user_name}'s Dashboard")
    end

    it 'has a button linking to the discover page', :vcr do
      expect(page).to have_button('Discover Movies')

      click_button('Discover Movies')

      expect(current_path).to eq(discover_index_path)
    end

    describe 'viewing party list' do
      describe 'happy path' do
        it 'displays a list of viewing parties the user is going to', :vcr do
          within('.viewing-parties') do
            within("#party-#{@party1.id}") do
              expect(page).to have_css('img')
              expect(page).to have_content(@party1.movie_title)
              expect(page).to have_content(@party1.date.strftime("%B %-d, %Y"))
              expect(page).to have_content(@party1.start_time.strftime("%-I:%M %p"))
            end
            within("#party-#{@party2.id}") do
              expect(page).to have_css('img')
              expect(page).to have_content(@party2.movie_title)
              expect(page).to have_content(@party2.date.strftime("%B %-d, %Y"))
              expect(page).to have_content(@party2.start_time.strftime("%-I:%M %p"))
            end
          end
          expect(page).to_not have_css("div#party-#{@party3.id}")
        end

        it 'lists Hosting with attendees names when the user is the host', :vcr do
          within('.viewing-parties') do
            within("#party-#{@party1.id}") do
              expect(page).to have_content('Hosting')

              @party1.attendees_names.each do |name|
                expect(page).to have_content(name)
              end
              expect(page).to_not have_content(@user4.user_name)
            end
          end
        end

        it 'lists Invited by host name with the user bolded in attendees list when the user is not the host', :vcr  do
          within('.viewing-parties') do
            within("#party-#{@party2.id}") do
              expect(page).to have_content("Invited by #{@user2.user_name}")

              @party2.attendees_names.each do |name|
                expect(page).to have_content(name)
              end
              expect(page).to have_css('p#user_name', 'style': 'font-weight:bold')
              expect(page).to_not have_content(@user3.user_name)
            end
          end
        end

        it 'displays message when no parties exist', :vcr do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user5)
          visit dashboard_path

          within('.viewing-parties') do
            expect(page).to have_content("click 'Discover Movies' and start a party!")
            expect(page).to_not have_css("div#party-#{@party1.id}")
            expect(page).to_not have_css("div#party-#{@party2.id}")
            expect(page).to_not have_css("div#party-#{@party3.id}")
          end
        end
      end
    end
  end
end
