class AddPayAccountToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :pay_account, :string
  end
end
