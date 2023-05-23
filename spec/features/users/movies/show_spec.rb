require 'rails_helper'

RSpec.describe 'Users Movies Details Page', type: :feature do
  describe 'As a registered user' do
    before(:each) do
      @movie = MovieFacade.new(550).find_movie
      @user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit user_movie_path(@user, @movie.id)
    end

    it 'displays the movie title, vote average, runtime, genre, and summary', :vcr do
      expect(page).to have_content(@movie.title)
      expect(page).to have_content("Rating: #{@movie.vote_average}")
      expect(page).to have_content("Runtime: #{@movie.runtime}")
      @movie.genre.each do |genre|
        expect(page).to have_content(genre)
      end
      expect(page).to have_content("Summary")
      expect(page).to have_content(@movie.summary)
    end

    it 'should display a button to the discover page', :vcr do
      expect(page).to have_button('Discover Page')

      click_button 'Discover Page'

      expect(current_path).to eq(user_discover_index_path(@user))
    end

    it 'should display a button to create a viewing party for the movie', :vcr do
      expect(page).to have_button("Create Viewing Party for #{@movie.title}")

      click_button "Create Viewing Party for #{@movie.title}"

      expect(current_path).to eq(new_user_movie_viewing_party_path(@user, @movie.id))
    end

    it 'lists 10 casts members for the movie', :vcr do
      expect(page).to have_content("Cast:")
      expect(page).to have_content("Edward Norton as The Narrator")
      expect(page).to have_content("Brad Pitt as Tyler Durden")
      expect(page).to have_content("Helena Bonham Carter as Marla Singer")
      expect(page).to have_content("Meat Loaf as Robert \"Bob\" Paulson")
      expect(page).to have_content("Jared Leto as Angel Face")
      expect(page).to have_content("Zach Grenier as Richard Chesler")
      expect(page).to have_content("Holt McCallany as The Mechanic")
      expect(page).to have_content("Eion Bailey as Ricky")
      expect(page).to have_content("Richmond Arquette as Intern")
      expect(page).to have_content("David Andrews as Thomas")
    end

    it 'lists all the reviews and the review count for the movie', :vcr do
      facade = MovieFacade.new(550)

      expect(page).to have_content("#{facade.review_count} Reviews:")
      facade.reviews.each do |review|
        expect(page).to have_content(review.author)
        expect(page).to have_content("Rating: #{review.rating}")
      end

      expect(page).to have_content("Pretty awesome movie. It shows what one crazy person can convince other crazy people to do. Everyone needs something to believe in. I recommend Jesus Christ, but they want Tyler Durden.")
      expect(page).to have_content("In my top 5 of all time favourite movies. Great story line and a movie you can watch over and over again.")
      expect(page).to have_content("Madness unbounded. Don't try to make sense of insanity, just ride a wild ride.")
    end
  end

  describe 'As a visitor' do
    it 'redirects to this page if a visitor clicks to create a party', :vcr do
      movie = MovieFacade.new(550).find_movie
      user = create(:user)

      visit user_movie_path(user, movie.id)
      click_on 'Create Viewing Party for Fight Club'

      expect(current_path).to eq(user_movie_path(user, movie.id))
      expect(page).to have_content('You must be logged in or registered to create a viewing party')
    end
  end
end
