angular.module("OpenHq").factory("TasksRepository", function($http) {
  return {
    /**
     * Reorders tasks in the given order
     * @param  {String/Integer} story_id [ID or slug for the story]
     * @param  {Array} ids [Array of task ids]
     * @return {Promise}
     */
    me: function() {
      return $http.get("/api/v1/tasks/me").then(function(resp) { return resp.data; });
    },

    /**
     * Reorders tasks in the given order
     * @param  {String/Integer} story_id [ID or slug for the story]
     * @param  {Array} ids [Array of task ids]
     * @return {Promise}
     */
    updateOrder: function(story_id, order) {
      return $http.put("/api/v1/tasks/order", { story_id: story_id, order: order });
    },

    /**
     * Deletes any completed tasks on a story
     * @param  {String/Integer} story_id [ID or slug for the story]
     * @return {Promise}
     */
    deleteCompleted: function(story_id) {
      return $http({
        method: "DELETE",
        url: "/api/v1/tasks/completed",
        params: { story_id: story_id }
      });
    }
  };
});
