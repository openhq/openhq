$(function(){
  $(document).on('click', '.confirm-dialog-wrapper .close-dialog', function(ev){
    $(this).closest('.confirm-dialog-wrapper').fadeOut(100);
  });
});

// Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}

// Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm"),
      title = link.data("confirm-title"),
      $confirm_dialog = $('.confirm-dialog-wrapper');

  if (title) {
    $confirm_dialog.find('h4.confirm-title').show().html(title);
  } else {
    $confirm_dialog.find('h4.confirm-title').hide();
  }
  $confirm_dialog.find('p.confirm-message').html(message);
  $confirm_dialog.find('a.button.confirm').off().on('click', function(ev){
    $.rails.confirmed(link);
  });
  $confirm_dialog.fadeIn(100);
}

// User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}