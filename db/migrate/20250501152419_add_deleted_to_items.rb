class AddDeletedToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :deleted, :boolean
  end
end
