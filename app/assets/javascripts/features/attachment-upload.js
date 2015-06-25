$(function(){

  $('#s3-uploader').S3Uploader({
    allow_multiple_files: true,
    before_add: function(data){
      // TODO: validate upload?
      return true;
    },
    progress_bar_target: $('#attachments-list')
  });

  $("#s3-uploader").on("s3_upload_complete", function(e, content) {
    $.ajax({
      type: "POST",
      url: window.location.pathname + "/attachments",
      data: {
        "attachment": {
          "name": content.filename,
          "file_name": content.filename,
          "file_size": content.filesize,
          "content_type": content.filetype,
          "file_path": decodeURIComponent(content.filepath.split("/")[2])
        }
      },
      dataType: "json"
    }).done(function(data) {
      console.log("Attachment added", data.attachment);
      var input = $('#comment_attachment_ids');
      input.val(input.val() + data.attachment.id + ',');

      // #TODO mark progress bar complete
      // re-enable submit button
    }).fail(function() {
      console.error("Error creating attachment", arguments);
    });
  });

});
