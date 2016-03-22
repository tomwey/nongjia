module WechatsHelper
  def render_navbar_for(title, left_item = {}, right_item = {})
    render '/wechat_shop/shared/navbar', left_item: left_item, title: title, right_item: right_item
  end
  def render_empty_result(msg = '喔，没有数据!!!')
    content_tag :div, msg, class: 'empty-result-box'
  end
  
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
  
  def notice_message
    flash_messages = []
    flash.each do |type, message|
      type = :success if type.to_s == "notice"
      type = :warning if type.to_s == "alert"
      type = :danger if type.to_s == "error"
      text = content_tag(:div, link_to("×", "#", class: "close", 'data-dismiss' => "alert") + message, class: "alert alert-#{type}", style: "margin-top: 20px;")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end
end
