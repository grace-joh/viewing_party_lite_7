require 'rails_helper'

RSpec.describe 'users movies results page', type: :feature do
  describe 'discover page button', :vcr do
    it 'displays the Discover Page button' do
      visit "/movies?q=''"
      expect(page).to have_button('Discover Page')

      click_button 'Discover Page'

      expect(current_path).to eq(discover_index_path)
    end
  end

  describe 'invalid search', :vcr do
    it 'returns alert if a search was invalid' do
      visit "/movies?q='asldkgjawof'"

      expect(page).to have_content('No movies found.')
    end
  end

  describe 'top rated movies', :vcr do
    it 'returns top rated movies' do
      visit '/movies?q=top%20rated'
      movies = MovieListFacade.new('top rated').top_rated

      movies.each do |movie|
        within("##{movie.id}") do
          expect(page).to have_content(movie.title)
          expect(page).to have_content(movie.vote_average)
        end
      end
    end

    it 'links title to each movies show page' do
      movies = MovieListFacade.new('top rated').top_rated

      visit '/movies?q=top%20rated'
      expect(page).to have_link(movies.first.title)
      click_link movies.first.title
      expect(current_path).to eq(movie_path(movies.first.id))

      visit '/movies?q=top%20rated'
      expect(page).to have_link(movies.last.title)
      click_link movies.last.title
      expect(current_path).to eq(movie_path(movies.last.id))

      # movies.each do |movie|
      #   visit "/movies?q=top%20rated"
      #   within("##{movie.id}") do
      #     expect(page).to have_link(movie.title)
      #     click_link movie.title
      #     expect(current_path).to eq(movie_path(movie.id))
      #   end
      # end
    end
  end

  describe 'searched movies', :vcr do
    it 'returns searched movies' do
      visit '/movies?q=princess'
      movies = MovieListFacade.new('princess').search

      movies.each do |movie|
        within("##{movie.id}") do
          expect(page).to have_content(movie.title)
          expect(page).to have_content(movie.vote_average)
        end
      end
    end

    it 'links title to each movies show page' do
      movies = MovieListFacade.new('princess').search

      visit '/movies?q=princess'
      expect(page).to have_link(movies.first.title)
      click_link movies.first.title
      expect(current_path).to eq(movie_path(movies.first.id))

      visit '/movies?q=princess'
      expect(page).to have_link(movies.last.title)
      click_link movies.last.title
      expect(current_path).to eq(movie_path(movies.last.id))

      # movies.each do |movie|
      #   visit '/movies?q=princess'
      #   within("##{movie.id}") do
      #     expect(page).to have_link(movie.title)
      #     click_link movie.title
      #     expect(current_path).to eq(movie_path(movie.id))
      #   end
      # end
    end
  end
end
