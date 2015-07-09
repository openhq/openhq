class FilesController < ApplicationController
  def index
    @attachments = Attachment.all_for_user(current_user)
  end
end
