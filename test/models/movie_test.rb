require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "add genres" do 
    movie = movies(:avengers)

    assert_difference('Genre.count', 1) do 
      movie.add_many 'Genre', ['Comedy', 'Action']
    end

    assert_equal 2, movie.genres.count
  end 

  test "add crews" do 
    movie = movies(:avengers)
    
    assert_difference('Crew.count', 1) do 
      movie.add_many 'Crew', ['Scarlett Johansson', 'Mark Ruffalo']
    end

    assert_equal 2, movie.crews.count
  end
end
