angular.module("OpenHq").factory("UsersRepository", function($http) {
  var teamUsers = [];

  return {

    /**
     * Fetch all users for the current team
     * @return {Promise}
     */
    all: function() {
      return teamUsers;
    },

    fetch: function() {
      return $http.get("/api/v1/users").then(function(resp) {
        teamUsers = resp.data.users;

        return teamUsers;
      });
    }
  };
}).run(function(UsersRepository) {
  UsersRepository.fetch();
});
