class CreateCrewsMovies < ActiveRecord::Migration
  def change
    create_table :crews_movies, id: false do |t|
      t.integer :crew_id, index: true, unique: true
      t.integer :movie_id, index: true
    end
  end
end
