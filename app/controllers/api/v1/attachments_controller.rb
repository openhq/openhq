require 'aws-sdk-v1'
require 'securerandom'

module Api
  module V1
    class AttachmentsController < BaseController
      before_action :set_story, only: [:index, :create]

      resource_description do
        short "Uploading and attaching files"
        formats ["json"]
      end

      def_param_group :attachment do
        param :attachment, Hash, desc: "Attachment Info" do
          param :file_path, String, desc: "File path from S3 e.g. 'uploads/my_image.jpg'", required: true
          param :file_name, String, desc: "File name e.g. 'my_image.jpg'", required: true
          param :name, String, desc: "Display name for the file", required: false
          param :file_size, Integer, desc: "File size in bytes", required: false
          param :content_type, String, desc: "Files content type", required: false
        end
      end

      api! "Fetch all attachments"
      param :story_id, String, desc: "Story ID or slug", required: true
      def index
        attachments = @story.attachments
        render json: attachments
      end

      api! "Fetch a single attachment"
      def show
        attachment = Attachment.find(params[:id])
        render json: attachment
      end

      api! "Create an attachment"
      param :story_id, String, desc: "Story ID or slug", required: true
      param_group :attachment
      def create
        attachment = Attachment.new(attachment_params.merge(
          owner: current_user,
          story: @story
        ))

        if attachment.save
          render json: attachment, status: 201
        else
          render_errors attachment
        end
      end

      api! "Update an attachment"
      param_group :attachment
      def update
        attachment = Attachment.find(params[:id])

        if attachment.update(attachment_params)
          render json: attachment
        else
          render_errors attachment
        end
      end

      api! "Delete an attachment"
      def destroy
        attachment = Attachment.find(params[:id])
        attachment.destroy
        render nothing: true, status: 204
      end

      api! "Get a presigned S3 URL to upload your file to"
      def presigned_upload_url
        new_file_name = "#{SecureRandom.uuid}/#{params[:file_name]}"

        s3 = AWS::S3.new
        obj = s3.buckets[ENV['AWS_S3_BUCKET']].objects["attachments/#{new_file_name}"]
        # TODO validate file type is allowed
        upload_url = obj.url_for(:put, expires: 3600, content_type: params[:file_type])

        resp = {
          file_path: obj.key,
          public_url: obj.public_url.to_s,
          upload_url: upload_url.to_s
        }

        render json: resp, status: 201
      end

      private

      def set_story
        @story = Story.friendly.find(params[:story_id])
        project = @story.project

        authorize! :read, project
      end

      def attachment_params
        params.require(:attachment).permit(:name, :file_name, :file_size, :content_type, :file_path)
      end
    end
  end
end
