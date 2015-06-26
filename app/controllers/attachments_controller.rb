class AttachmentsController < ApplicationController

  def create
    @attachment = Attachment.new(attachment_params.merge(
      owner: current_user,
      story: Story.friendly.find(params[:story_id])
    ))

    if @attachment.save
      render json: { attachment: @attachment }
    else
      render json: { error: @attachment.errors.full_messages.first }, status: 400
    end
  end

  private

  def attachment_params
    params.require(:attachment).permit(:name, :file_name, :file_size, :content_type, :file_path)
  end

end
