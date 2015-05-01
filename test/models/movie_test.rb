require 'test_helper'

class MovieTest < ActiveSupport::TestCase

  def setup 
    @movie = movies(:avengers)
  end

  test "add genres" do 
    assert_difference('Genre.count', 1) do 
      @movie.add_many 'Genre', ['Comedy', 'Action']
    end

    assert_equal 2, @movie.genres.count
  end 

  test "add crews" do     
    assert_difference('Crew.count', 1) do 
      @movie.add_many 'Crew', ['Scarlett Johansson', 'Mark Ruffalo']
    end

    assert_equal 2, @movie.crews.count
  end

  test "add wrong type" do 
    assert_raises Movie::RelationError do 
      @movie.add_many 'Blah', ['Stuff', 'Another Stuff']
    end
  end 
end
