class AddModAndChangelogToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :mod, :boolean
    add_column :posts, :changelog, :boolean
  end
end
