# 用于记录特定的cache version
class CacheVersion
  def self.method_missing(method, *args)
    method_name = method.to_s
    super(method, *args)
  rescue NoMethodError
    if method_name =~ /=$/
      var_name = method_name.sub('='.freeze, ''.freeze)
      key = CacheVersion.mk_key(var_name)
      value = args.first.to_s
      # save
      Rails.cache.write(key, value)
    else
      key = CacheVersion.mk_key(method)
      Rails.cache.read(key)
    end
  end
  
  def self.product_latest_updated_at
    key = CacheVersion.internal_updated_key
    if key.blank?
      CacheVersion.save_product_latest_updated_time(Time.now)
      key = CacheVersion.internal_updated_key
    end
    key
  end
  
  def self.save_product_latest_updated_time(time)
    CacheVersion.internal_updated_key = time.to_i.to_s
  end
  
  private
  def self.mk_key(key)
    "cache_version:#{key}"
  end
  
end