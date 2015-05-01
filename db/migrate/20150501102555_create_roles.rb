class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :movie, index: true
      t.references :crew, index: true
      t.string :job

      t.timestamps null: false
    end
    add_foreign_key :roles, :movies
    add_foreign_key :roles, :crews
  end
end
