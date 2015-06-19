class AttachmentsController < ApplicationController

  def create
    @attachment = Attachment.new(
      owner: current_user,
      story: Story.friendly.find(params[:story_id]),
      attachment: attachment_params[:file]
    )

    if @attachment.save
      render json: { success: true, attachment: @attachment }
    else
      render json: { success: false, error: @attachment.errors.full_messages.first }
    end
  end

  private

  def attachment_params
    params.require(:attachment).permit(:file)
  end

end