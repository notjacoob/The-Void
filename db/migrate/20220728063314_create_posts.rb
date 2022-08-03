class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :content
      t.string :user
      t.integer :likes
      t.datetime :date

      t.timestamps
    end
  end
end
