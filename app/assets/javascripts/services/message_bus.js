angular.module("OpenHq").run(function($rootScope, CurrentUser) {
  CurrentUser.get(function(user) {
    var bus = window.MessageBus;
    bus.subscribe("/user/"+user.id+"/notifications", function(data) {
      $rootScope.$broadcast('notification:new', data);
    });
  });
});