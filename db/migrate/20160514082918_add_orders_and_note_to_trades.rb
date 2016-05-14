class AddOrdersAndNoteToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :orders, :integer, array: true, default: [] 
    add_column :trades, :note, :string
  end
end
