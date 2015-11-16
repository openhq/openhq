angular.module("OpenHq").factory("Notification", function(railsResourceFactory) {

  return railsResourceFactory({
    url: "/api/v1/notifications",
    name: "notification"
  });

});


