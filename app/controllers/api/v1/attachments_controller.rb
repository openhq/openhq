require 'aws-sdk-v1'
require 'securerandom'

module Api
  module V1
    class AttachmentsController < BaseController
      before_action :set_story

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
      def index
        attachments = @story.attachments
        render json: attachments
      end

      api! "Fetch a single attachment"
      def show
        attachment = @story.attachments.find(params[:id])
        render json: attachment
      end

      api! "Create an attachment"
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
        attachment = @story.attachments.find(params[:id])

        if attachment.update(attachment_params)
          render json: attachment
        else
          render_errors attachment
        end
      end

      api! "Delete an attachment"
      def destroy
        attachment = @story.attachments.find(params[:id])
        attachment.destroy
        render nothing: true, status: 204
      end

      api! "Get a presigned S3 URL to upload your file to"
      def presigned_upload_url
        new_file_name = "attachment_#{@project.id}_#{@story.id}_#{SecureRandom.uuid}"

        s3 = AWS::S3.new
        obj = s3.buckets[ENV['AWS_S3_BUCKET']].objects["attachments/#{new_file_name}"]
        url = obj.url_for(:write, content_type: "text/plain")

        render json: {url: url.to_s}, status: 201
      end

      private

      def set_story
        @project = current_team.projects.friendly.find(params[:project_id])
        @story = @project.stories.friendly.find(params[:story_id])

        authorize! :read, @project
      end

      def attachment_params
        params.require(:attachment).permit(:name, :file_name, :file_size, :content_type, :file_path)
      end
    end
  end
end
