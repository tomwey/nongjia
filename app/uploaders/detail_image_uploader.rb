# encoding: utf-8
require 'digest/md5'
class DetailImageUploader < BaseUploader

  process resize_to_limit: [1280, nil]

  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(current_path)
      "#{@name}.#{file.extension.downcase}"
    end
  end
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def extension_white_list
    %w(jpg jpeg png webp)
  end
  
  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

end
