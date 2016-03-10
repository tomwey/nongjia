module API
  module V1
    class ProductsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :products do
        desc "获取某个类别下面的所有产品"
        params do
          requires :category_id, type: Integer, desc: "类别ID"
          use :pagination
        end
        get do
          @category = Category.find_by(id: params[:category_id])
          if @category.blank?
            return render_error(4004, "类别不存在")
          end
          
          @items = @category.products.no_delete.saled.hot
          @items = @items.paginate(page: params[:page], per_page: page_size) if params[:page]
          
          render_json(@items, API::V1::Entities::Product)
        end # end get /
        
        desc "获取产品详情"
        get '/:product_id' do
          @product = Product.find_by(id: params[:product_id], visible: true)
          
          render_json(@product, API::V1::Entities::ProductDetail)
        end # end get /1.json
        
      end # end resource products
      
    end
  end
end