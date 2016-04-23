module ProductsHelper
  def render_stock_tag(product)
    return '' if product.blank?
    
    msg = product.has_stock? ? SiteConfig.ship_and_stock_info : '无货'
    content_tag :p, msg, class: 'stock-info'
    
  end
end