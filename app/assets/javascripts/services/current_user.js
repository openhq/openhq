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

        callback.call(cbContext, user);
      });
    },

    update: function(user){
      return $http.put("/api/v1/user", {user:user}).then(function(userResp) {
        return userResp.data.user;
      });
    },

    updatePassword: function(user){
      return $http.put("/api/v1/user/password", {user:user}).then(function(userResp) {
        return userResp.data.user;
      });
    }
  };

});


