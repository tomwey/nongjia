class User < ActiveRecord::Base
  
  has_many :authorizations, dependent: :destroy, inverse_of: :user
  has_many :orders, inverse_of: :user
  has_many :shipments, dependent: :destroy, inverse_of: :user
  
  has_one  :wechat_auth
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
  
  # 生成唯一的优惠推荐码
  before_create :generate_nb_code
  def generate_nb_code
    # 生成6位随机码, 系统的推荐码是5位数
    begin
      self.nb_code = SecureRandom.hex(3) #if self.nb_code.blank?
    end while self.class.exists?(:nb_code => nb_code)
  end
  
  # 初次注册生成一个优惠券
  after_create :generate_coupon
  def generate_coupon
    # TODO
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
  
  def self.from_wechat_auth(result)
    auth = WechatAuth.find_by(open_id: result['openid'])
    if auth.blank?
      user = User.new
      auth = WechatAuth.new(open_id: result['openid'],
                            access_token: result['access_token'],
                            refresh_token: result['refresh_token'])
      user.wechat_auth = auth
      user.save!
    else
      auth.access_token = result['access_token']
      auth.refresh_token = result['refresh_token'];
      auth.save!
      user = auth.user;
    end
    
    # 获取用户信息
    if user.nickname.blank? or user.avatar.blank?
      resp = RestClient.get "https://api.weixin.qq.com/sns/userinfo", 
                     { :params => { 
                                    :access_token => auth.access_token,
                                    :openid       => auth.open_id,
                                    :lang         => 'zh_CN'
                                  } 
                     }
      result = JSON.parse(resp)
      if result['openid'].present?
        # 正确取到用户数据
        @user.nickname = result['nickname']
        @user.remote_avatar_url = result['headimgurl'] 
        @user.save!
      end
    end
    
    user
    
  end
  
end
