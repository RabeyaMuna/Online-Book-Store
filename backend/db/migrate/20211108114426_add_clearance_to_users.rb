class AddClearanceToUsers < ActiveRecord::Migration[6.1]
  def self.up
    change_table :users do |t|
      t.string :encrypted_password, limit: 128
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128
    end

    add_index :users, :remember_token

    users = select_all('SELECT id FROM users WHERE remember_token IS NULL')

    users.each do |user|
      update <<-SQL.squish
        UPDATE users
        SET remember_token = '#{Clearance::Token.new}'
        WHERE id = '#{user['id']}'
      SQL
    end
  end

  def self.down
    remove_index :users, :remember_token

    change_table :users do |t|
      t.remove :encrypted_password, :confirmation_token, :remember_token
    end
  end
end
