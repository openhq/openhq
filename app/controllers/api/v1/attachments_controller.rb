require 'aws-sdk-v1'

module Api
  module V1
    class AttachmentsController < BaseController

      def presigned_upload_url
        s3 = AWS::S3.new

        obj = s3.buckets['BucketName'].objects['KeyName']
        # Replace BucketName with the name of your bucket.
        # Replace KeyName with the name of the object you are creating or replacing.

        url = obj.url_for(:write, :content_type => "text/plain")
      end

      def create
        # @attachment = Attachment.new(attachment_params.merge(
        #   owner: current_user,
        #   story: Story.friendly.find(params[:story_id])
        # ))

        # if @attachment.save
        #   render json: { attachment: @attachment }
        # else
        #   render json: { error: @attachment.errors.full_messages.first }, status: 400
        # end
      end

      private

      def attachment_params
        # params.require(:attachment).permit(:name, :file_name, :file_size, :content_type, :file_path)
      end
    end
  end
end

# id integer NOT NULL,
# name character varying,
# attachable_type character varying,
# attachable_id integer,
# story_id integer,
# owner_id integer,
# created_at timestamp without time zone,
# updated_at timestamp without time zone,
# file_name character varying,
# file_size integer,
# content_type character varying,
# file_path character varying,
# process_data json DEFAULT '{}'::json,
# process_attempts integer DEFAULT 0,
# processed_at timestamp without time zone,
# team_id integer
