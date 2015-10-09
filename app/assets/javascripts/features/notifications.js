App.onPageLoad(function() {
  var $notification_menu_item = $('.main-menu-item.notifications'),
      no_notifications_template = JST['templates/notifications/no_notifications'];

  // When the page loads,
  // add any unseen notifications to the menu
  $.ajax({
    method: "GET",
    url: "/notifications",
    dataType: "json"
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
    var new_count = 0;

    // add all the notifications
    if (notifications.length > 0) {
      $notification_menu_item.addClass('has-unseen');

      _.each(notifications, function(n){
        addNotification(n);
        if (!n.seen) new_count++;
      });

    // no new notifications
    } else {
      $notification_menu_item.find('ul.notification-list').append(no_notifications_template());
    }

    // notification count icon
    if (new_count > 0) {
      $notification_menu_item.find('span.notification-count').text(new_count).show();
    }

    // notification count title
    $notification_menu_item.find('p.notification-count').text(
      new_count+" new notification"+(new_count == 1 ? "" : "s")
    );
  }

  // appends a single notification to the menu
  function addNotification(n) {
    var template_filename = (n.notifiable_type+'_'+n.action_performed).toLowerCase(),
        template = JST['templates/notifications/'+template_filename];

    $notification_menu_item.find('ul.notification-list').append(template(n));
  }

  $(document).on("click", ".ui-dropdown-menu.notifications .icon", function() {
    // if there are any unseen notifications, mark them all as read and
    // remove the unseen class from the menu icon
    if ($notification_menu_item.hasClass('has-unseen')) {
      $notification_menu_item.removeClass('has-unseen');
      $notification_menu_item.find('span.notification-count').hide();
      $.ajax({
        url: "/notifications/mark_all_seen",
        method: "PUT"
      });
    }
  });
});