class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.text :synopsis

      t.timestamps null: false
    end
  end
end
