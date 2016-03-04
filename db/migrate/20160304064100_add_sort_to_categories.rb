class AddSortToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :sort, :integer, default: 0
    add_index  :categories, :sort
  end
end
