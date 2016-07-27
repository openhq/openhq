angular.module("OpenHq").factory("TasksRepository", function($http, Comment) {
  return {

    /**
     * Finds a single task
     */
    find: function(id) {
      return $http.get("/api/v1/tasks/"+id).then(function(resp) {
            var task = resp.data.task;

            // Wrap all comments in models
            task.comments = task.comments.map(function(commentData) {
              return new Comment(commentData);
            }).reverse();

            return task;
        });
    },

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
