class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.belongs_to :follower
      t.belongs_to :followed

      t.timestamps null: false
    end

    add_index :relationships, :followed_id
    add_index :relationships, :follower_id
   add_index :relationships, [:followed_id, :follower_id], unique: true # prevents users entering duplicates using an application like curl
  end
end
