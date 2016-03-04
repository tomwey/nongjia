class AddImagesAndDetailImagesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :images,        :string, array: true, default: []
    add_column :products, :detail_images, :string, array: true, default: []
  end
end
