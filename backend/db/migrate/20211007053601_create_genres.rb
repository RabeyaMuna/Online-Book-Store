class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres do |t|
      t.citext :name, index: true, null: false

      t.timestamps
    end
  end
end
