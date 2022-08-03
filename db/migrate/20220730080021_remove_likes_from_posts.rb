class RemoveLikesFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :likes, :integer
  end
end
