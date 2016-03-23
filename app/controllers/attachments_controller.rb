class AttachmentsController < ApplicationController
  
  before_filter :allow_ajax_request_from_other_domains

   def allow_ajax_request_from_other_domains
     headers['Access-Control-Allow-Origin'] = '*'
     headers['Access-Control-Request-Method'] = '*'
     headers['Access-Control-Allow-Headers'] = '*'
   end
   
  def create
    # Attachment.create!(file: params[:file])
    puts params
    attachment = Attachment.new(file_params)
    if attachment.save
      head :no_content
    else
      
    end
  end
  
  private
  def file_params
    params.requires(:attachment).permit(:file)
  end
end
