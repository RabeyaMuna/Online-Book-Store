class DeletePasswordDigestFromUsers < ActiveRecord::Migration[6.1]
  def up
    remove_column :users, :password_digest, :string
  end

  def down
    add_column :users, :password_digest, :string, null: false, default: ""
  end
end
