class Shipment < ActiveRecord::Base
  belongs_to :user, inverse_of: :shipments
  
  validates :name, :mobile, :address, :region, presence: true
  validates :mobile, format: { with: /\A1[3|4|5|7|8][0-9]\d{4,8}\z/, message: "号码不正确" },
                     length: { is: 11 }
                     
  def hack_mobile
    return "" if self.mobile.blank?
    hack_mobile = String.new(self.mobile)
    hack_mobile[3..6] = "****"
    hack_mobile
  end
  
end
