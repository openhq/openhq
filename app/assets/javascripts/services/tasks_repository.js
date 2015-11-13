angular.module("OpenHq").factory("TasksRepository", function($http) {
  return {
    /**
     * Reorders tasks in the given order
     * @param  {String/Integer} story_id [ID or slug for the story]
     * @param  {Array} ids [Array of task ids]
     * @return {Promise}
     */
    updateOrder: function(story_id, order) {
      $http.put("/api/v1/tasks/order", { story_id: story_id, order: order });
    }
  };
});
