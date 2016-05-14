class AddPayBuyerLossToOrderProducts < ActiveRecord::Migration
  def change
    add_column :order_products, :pay_buyer_loss, :decimal, precision: 8, scale: 2, default: 0
  end
end
