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

    invitedUsers: function() {
      return $http.get("/api/v1/team_invites").then(function(resp) { return resp.data.users });
    },

    invite: function(user) {
      return $http({
        url: "/api/v1/team_invites",
        method: "POST",
        data: { user: user }
      });
    },

    fetch: function() {
      return $http.get("/api/v1/users").then(function(resp) {
        // Push users into the existing array so all classes that already
        // have a copy of it will receive new users
        resp.data.users.forEach(function(user) {
          teamUsers.push(user);
        });

        return teamUsers;
      });
    },

    usersSelectArray: function() {
      return $http.get("/api/v1/users").then(function(resp) {
        return resp.data.users.map(function(user) {
          return [user.display_name, parseInt(user.id, 10)];
        });
      });
    }
  };
}).run(function(UsersRepository) {
  UsersRepository.fetch();
});
