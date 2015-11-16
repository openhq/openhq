angular.module("OpenHq").factory("CurrentUser", function($http, $rootScope) {
  var user;

  return {
    get: function(callback, cbContext) {
      if (user) {
        return callback.call(cbContext, user);
      }

      $http.get("/api/v1/user").then(function(userResp) {
        // cache user for later calls
        user = userResp.data.user;

        // subscribe the user to get notifications
        var bus = window.MessageBus;
        bus.subscribe("/user/"+user.id+"/notifications", function(data) {
          $rootScope.$broadcast('notification:new', data);
        });

        callback.call(cbContext, user);
      });
    }
  };

});


