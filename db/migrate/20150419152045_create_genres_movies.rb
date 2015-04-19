class CreateGenresMovies < ActiveRecord::Migration
  def change
    create_table :genres_movies, id: false do |t|
      t.integer :genre_id, index: true, unique: true
      t.integer :movie_id, index: true
    end
  end
end
