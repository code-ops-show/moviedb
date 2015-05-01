require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "add new genre" do 
    movie = movies(:avengers)

    assert_difference('Genre.count', 1) do 
      movie.add_genres = ['Comedy', 'Action']
    end
  end 
end
