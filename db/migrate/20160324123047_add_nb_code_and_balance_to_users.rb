class AddNbCodeAndBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nb_code, :string # 优惠推荐码
    add_column :users, :balance, :integer, default: 0
    add_index :users, :nb_code, unique: true
  end
end
