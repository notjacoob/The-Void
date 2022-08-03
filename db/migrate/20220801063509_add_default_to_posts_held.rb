class AddDefaultToPostsHeld < ActiveRecord::Migration[6.1]
  def change
    change_column_default :posts, :held, false
  end
end
