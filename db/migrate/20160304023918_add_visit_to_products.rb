class AddVisitToProducts < ActiveRecord::Migration
  def change
    add_column :products, :visit, :integer, default: 0
  end
end
