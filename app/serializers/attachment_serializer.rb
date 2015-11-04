require 's3_url_signer'

class AttachmentSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper

  attributes :id, :name, :attachable_type, :attachable_id, :url, :preview_url, :story_id, :owner_id, :file_name, :file_path, :file_size, :human_file_size, :content_type, :process_data, :process_attempts, :processed_at, :created_at, :updated_at
  has_one :owner

  def human_file_size
    number_to_human_size object.file_size
  end

  def preview_url
    thumb_url = object.process_data["thumbnail:tile"]

    if thumb_url.present?
      S3UrlSigner.sign(thumb_url)
    else
      ActionController::Base.helpers.image_url "file_types/#{object.icon_name}.png"
    end
  end

end
