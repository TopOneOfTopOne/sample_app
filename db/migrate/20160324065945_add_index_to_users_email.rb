class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true # analogous to book index helps to search faster, here adding index to users table for email and forcing all emails to be unique in database
  end
end
