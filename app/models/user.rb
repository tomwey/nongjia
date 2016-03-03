class User < ActiveRecord::Base
  validates :mobile, presence: true
  validates :mobile, format: { with: /\A1[3|4|5|7|8][0-9]\d{4,8}\z/, message: "请输入11位正确的手机号" },
                     length: { is: 11 }, 
                     uniqueness: true
  
  mount_uploader :avatar, AvatarUploader
  # 生成private_token
  before_create :generate_private_token
  def generate_private_token
    self.private_token = SecureRandom.uuid.gsub('-', '') if self.private_token.blank?
  end
  
end
