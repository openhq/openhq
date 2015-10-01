App.onPageLoad(function() {
  var $notification_menu_item = $('.main-menu-item.notifications'),
      no_notifications_template = JST['templates/notifications/no_notifications'];

  // When the page loads,
  // add any unseen notifications to the menu
  $.ajax({
    method: "GET",
    url: "/notifications/unseen",
  })
  .done(function(resp){
    addAllNotifications(resp.notifications);
  })
  .fail(function(resp){
    console.error('something went wrong getting the notifications', resp);
    addAllNotifications([]);
  });

  // Adds an array of notifications to the dropdown menu
  function addAllNotifications(notifications) {
    // notification count title
    $notification_menu_item.find('p.notification-count').text(
      notifications.length+" Notification"+(notifications.length == 1 ? "" : "s")
    );

    // add all the notifications
    if (notifications.length > 0) {
      _.each(notifications, function(n){
        addNotification(n);
      });

    // no new notifications
    } else {
      $notification_menu_item.find('ul.notification-list').append('<li>'+no_notifications_template()+'</li>');
    }
  }

  // appends a single notification to the menu
  function addNotification(n) {
    var template_filename = (n.notifiable_type+'_'+n.action_performed).toLowerCase(),
        template = JST['templates/notifications/'+template_filename];

    console.log('add notification', n);

    $notification_menu_item.find('ul.notification-list').append(
      '<li>'+template(n)+'</li>'
    );
  }
});