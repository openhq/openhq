require 'aws-sdk-v1'
require 'securerandom'

module Api
  module V1
    class AttachmentsController < BaseController
      before_action :set_story

      def index
        attachments = @story.attachments
        render json: attachments
      end

      def show
        attachment = @story.attachments.find(params[:id])
        render json: attachment
      end

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

      def update
        attachment = @story.attachments.find(params[:id])

        if attachment.update(attachment_params)
          render json: attachment
        else
          render_errors attachment
        end
      end

      def destroy
        attachment = @story.attachments.find(params[:id])
        attachment.destroy
        render nothing: true, status: 204
      end

      def presigned_upload_url
        new_file_name = "attachment_#{@project.id}_#{@story.id}_#{SecureRandom.uuid}"

        s3 = AWS::S3.new
        obj = s3.buckets[ENV['AWS_S3_BUCKET']].objects["attachments/#{new_file_name}"]
        url = obj.url_for(:write, :content_type => "text/plain")

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
