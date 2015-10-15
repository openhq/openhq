var $notification_menu_item,
    no_notifications_template = JST['templates/notifications/no_notifications'];

// When the page loads add notifications
App.onPageLoad(function() {
  $notification_menu_item = $('.main-menu-item.notifications');

  $.ajax({
    method: "GET",
    url: "/notifications",
    dataType: "json"
  })
  .done(function(resp){
    addNotifications(resp.notifications);
  })
  .fail(function(resp){
    console.error('something went wrong getting the notifications', resp);
    addNotifications([]);
  });
});

// When theres a new notification
$(document).on('notification:new', function(ev, data){
  $.ajax({
    url: "/api/notification/"+data.id,
    method: "GET",
    dataType: "json"
  })
  .done(function(data){
    addNotification(data.notification);
    updateNotificationCount();
  });
});

// Adds an array of notifications to the dropdown menu
function addNotifications(notifications) {
  var new_count = 0;

  // add all the notifications
  if (notifications.length > 0) {
    _.each(notifications.reverse(), function(n){
      addNotification(n);
    });

  // no new notifications
  } else {
    $notification_menu_item.find('ul.notification-list').append(no_notifications_template());
  }

  updateNotificationCount();
}

function updateNotificationCount(){
  var new_count = $notification_menu_item.find('li.unseen').length;

  // notification count icon
  if (new_count > 0) {
    $notification_menu_item.addClass('has-unseen');
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

  $notification_menu_item.find('ul.notification-list').prepend(template(n));
}

// opening the notifications dropdown
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

    setTimeout(function() {
      $notification_menu_item.find('li.unseen').removeClass('unseen');
      updateNotificationCount();
    }, 3000);
  }
});