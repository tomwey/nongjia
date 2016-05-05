class WXShare
  attr_accessor :icon_url, :link, :title, :body
  def initialize(icon_url, link, title, body)
    @title = title
    @icon_url = icon_url
    @link = link
    @body = body
  end
end