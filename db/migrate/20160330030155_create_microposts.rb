class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :microposts, [:user_id, :created_at] # need this because we intend to display posts newest first
  end
end
