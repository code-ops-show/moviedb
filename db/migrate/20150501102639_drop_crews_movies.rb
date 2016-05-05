class DropCrewsMovies < ActiveRecord::Migration
  def change
    drop_table :crews_movies
  end
end
