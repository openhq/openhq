$(function(){

  $('#attachment-uploads').fileupload({
    add: function(e, data) {
      // TODO: add validation on content type?
      data.context = $(tmpl("template-upload", data.files[0]));
      $('#attachments-list').append(data.context);
      data.submit();
    },

    progress: function(e, data) {
      if (data.context) {
        progress = parseInt(data.loaded / data.total * 100, 10);
        data.context.find('.bar').css('width', progress + '%');
      }
    },

    done: function(e, data) {
      var attachment_id = data.result.attachment.id;
      var input = $('input[name="comment[attachment_ids]"]');
      input.val(input.val() + attachment_id + ',');

      data.context.addClass('complete');
    }
  });

});