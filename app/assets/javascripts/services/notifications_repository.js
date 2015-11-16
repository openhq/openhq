angular.module("OpenHq").factory("NotificationsRepository", function($http) {
  return {
    /**
     * Gets all recent notifications
     * @return {Promise}
     */
    recent: function() {
      return $http.get("/api/v1/notifications/unseen?include_seen=true").then(function(resp) {
        return resp.data.notifications;
      });
    },

    /**
     * Marks any unseen notifications as seen
     */
    markAllAsSeen: function() {
      return $http.put("/api/v1/notifications/mark_all_seen");
    }
  };
});


