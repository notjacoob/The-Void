class AddLastPostToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_post, :datetime
  end
end
