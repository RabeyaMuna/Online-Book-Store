class AddUniqueIndexToGenreName < ActiveRecord::Migration[6.1]
  def up
    remove_index :genres, :name
    add_index :genres, :name, unique: true
  end

  def down
    remove_index :genres, :name, unique: true
    add_index :genres, :name
  end
end
