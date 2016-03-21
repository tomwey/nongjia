module WechatsHelper
  def back_button
    content_tag(:a, class: 'nb-circle-button', href: "javascript:history.go(-1);") do
      content_tag :i, '', class: "fa fa-arrow-left"
    end
  end
  
  def home_button
    content_tag(:a, class: 'nb-circle-button', href: "#{wechat_shop_root_path}") do
      content_tag :i, '', class: "fa fa-home"
    end
  end
end
