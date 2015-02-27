$(function(){

  $('.tasks li input[type=checkbox]').on('change', function(e){
    var $this = $(this);
    var li = $this.closest('li');
    var url = $this.closest('form').attr('action');
    var completed = $this.is(':checked');

    // Do the work
    $.ajax({
        type: "put",
        url: url,
        data: {
          completed: completed
        }
    })
    .done(function(resp){
        if (resp.result) {
            if (resp.task.completed) li.addClass('complete');
            else li.removeClass('complete');
        }
    });
  });

});