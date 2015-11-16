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
     * Finds a single notification by id
     * @param  {Integer} id
     * @return {Promise}
     */
    find: function(id) {
      return $http.get("/api/v1/notifications/"+id).then(function(resp){
        return resp.data.notification;
      });
    },

    /**
     * Marks any unseen notifications as seen
     */
    markAsSeen: function(ids) {
      $http.put("/api/v1/notifications/mark_as_seen", {ids: ids});
    }
  };
});


