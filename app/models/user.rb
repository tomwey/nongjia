class User < ActiveRecord::Base
  
  has_many :authorizations, dependent: :destroy, inverse_of: :user
  has_many :orders, inverse_of: :user
  has_many :shipments, dependent: :destroy, inverse_of: :user
  # validates :mobile, presence: true
  # validates :mobile, format: { with: /\A1[3|4|5|7|8][0-9]\d{4,8}\z/, message: "请输入11位正确的手机号" },
  #                    length: { is: 11 },
  #                    uniqueness: true
  
  mount_uploader :avatar, AvatarUploader
  # 生成private_token
  before_create :generate_private_token
  def generate_private_token
    self.private_token = SecureRandom.uuid.gsub('-', '') if self.private_token.blank?
  end
  
  def avatar_url(size)
    if avatar.blank?
      "avatar/#{size}.png"
    else
      avatar.url(size)
    end
  end
  
  def block!
    self.verified = false
    self.save!
  end
  
  def unblock!
    self.verified = true
    self.save!
  end
  
end
