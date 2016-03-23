module API
  module V1
    class AttachmentsAPI < Grape::API
      
      resource :attachments do
        post do
          attachment = Attachment.create!(file: params[:file])
          { file_url: attachment.file.url  }
        end
      end
      
    end
  end
end