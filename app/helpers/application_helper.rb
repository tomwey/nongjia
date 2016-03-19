module ApplicationHelper
  
  def render_mobile_grid_for(collection, partial, columns = 3)
    return "" if collection.blank?
    return "" if columns <= 0
    
    html = ""
    collection.each_with_index do |item, index|
      if index % columns == 0
        html += '<div class="row">'
      end
      
      html += render partial, item: item, index: index
      
      if (index % columns == columns - 1) or (index == collection.size - 1)
        html += '</div>'
      end
      
    end
    html.html_safe
  end
  
end
