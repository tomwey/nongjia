class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :image, null: false
      t.string :link
      t.integer :sort, default: 0
      t.string :title
      t.string :body

      t.timestamps null: false
    end
    add_index :ads, :sort
  end
end
