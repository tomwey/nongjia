class AddSortToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sort, :integer, default: 0
    add_index :products, :sort
  end
end
