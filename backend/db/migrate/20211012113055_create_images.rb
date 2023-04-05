class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true, index: true, null: false
      t.string :name
      t.string :image_path, null: false

      t.timestamps
    end
  end
end
