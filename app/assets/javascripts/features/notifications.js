$(function(){
  $(document).ready(function(){
    setUserNotifications(App.user_notifications);
  });

  function setUserNotifications(notifications) {
    if (notifications.length) {
      console.log('adding notifications', notifications.length);
    } else {
      console.log('no notifications to add...');
    }
  }
});