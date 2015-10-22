class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :attachable_type, :attachable_id, :story_id, :owner_id, :file_name, :file_path, :file_size, :content_type, :process_data, :process_attempts, :processed_at, :created_at, :updated_at
  has_one :owner
end
