class AddDefaultLastPostTimeToUser < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :last_post, DateTime.now
  end
end
