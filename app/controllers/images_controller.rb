class ImagesController < ApplicationController
  before_action :set_product
  def create
    add_more_images(images_params[:images])
    flash[:error] = "上传图片失败" unless @product.save
    redirect_to :back
  end
  
  private
  def set_product
    @product = Product.find(params[:product_id])
  end
  
  def add_more_images(new_images)
    images = @product.images # copy old images
    images += new_images
    @product.images = images
  end
  
  def images_params
    params.require(:product).permit({images: []})
  end
end
