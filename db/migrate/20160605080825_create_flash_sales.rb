class CreateFlashSales < ActiveRecord::Migration
  def change
    create_table :flash_sales do |t|
      t.datetime :begin_time, null: false
      t.datetime :end_time,   null: false
      t.string :title
      t.string :body

      t.timestamps null: false
    end
  end
end
