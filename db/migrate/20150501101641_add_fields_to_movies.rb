class AddFieldsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :country, :string
    add_column :movies, :year, :integer
    add_column :movies, :review, :float
    add_column :movies, :rating, :string
    add_column :movies, :runtime, :integer
    add_column :movies, :language, :string
  end
end
