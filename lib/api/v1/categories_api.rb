module API
  module V1
    class CategoriesAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :categories do
        desc "获取所有的类别，并且按照sort字段的值升序"
        get do
          @categories = Category.order('sort ASC, id DESC')
          render_json(@categories, API::V1::Entities::Category)
        end # end get /
        
        desc "获取某个类别下的所有产品"
        params do
          use :pagination
        end
        get '/:category_id/products' do
          @category = Category.find_by(id: params[:category_id])
          if @category.blank?
            return render_error(4004, "不存在的类别")
          end
          
          @items = @category.products.no_delete.saled.hot
          @items = @items.paginate(page: params[:page], per_page: page_size) if params[:page]
          
          render_json(@items, API::V1::Entities::Product)
          
        end # end get /1/products
      end # end resource categories
    end
  end
end