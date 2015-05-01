require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "add genres" do 
    movie = movies(:avengers)

    assert_difference('Genre.count', 1) do 
      movie.add_genres = ['Comedy', 'Action']
    end
  end 

  test "add crews" do 
    movie = movies(:avengers)
    assert_difference('Crew.count', 1) do 
      movie.add_crews = ['Scarlett Johansson', 'Mark Ruffalo']
    end
  end
end
