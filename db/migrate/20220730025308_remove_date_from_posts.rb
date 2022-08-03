class RemoveDateFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :date, :datetime
  end
end
