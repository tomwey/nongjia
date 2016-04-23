module ProductsHelper
  def render_stock_tag(product)
    return '' if product.blank?
    
    msg = product.stock <= 0 ? '无货' : SiteConfig.ship_and_stock_info
    content_tag :p, msg, class: 'stock-info'
    
  end
end