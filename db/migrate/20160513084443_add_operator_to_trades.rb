class AddOperatorToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :operator, :integer
    add_index :trades, :operator
  end
end
