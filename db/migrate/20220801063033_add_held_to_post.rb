class AddHeldToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :held, :boolean
  end
end
