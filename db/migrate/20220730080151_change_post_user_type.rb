class ChangePostUserType < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :user, :string
    add_reference :posts, :user, index: true
  end
end
