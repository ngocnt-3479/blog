class AddIsPrivateColumnToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :isPrivate, :boolean, :default => false
  end
end
