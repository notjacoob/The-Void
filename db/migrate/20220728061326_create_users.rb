class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :hash
      t.boolean :admin
      t.boolean :banned

      t.timestamps
    end
  end
end
