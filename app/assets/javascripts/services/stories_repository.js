angular.module("OpenHq").factory("StoriesRepository", function($http, Story, Task, Comment) {
  return {

    /**
     * Fetch a single story and wraps tasks and comments in their own models
     * @param  {String/Integer}   id       [ID or slug for the story]
     * @return {Promise}
     */
    find: function(id) {
      return Story.get(id).then(function(story) {
        // Wrap all tasks in models
        story.tasks = story.tasks.map(function(taskData) {
          return new Task(taskData);
        });

        // Wrap all comments in models
        story.comments = story.comments.map(function(commentData) {
          return new Comment(commentData);
        });

        return story;
      });
    },

    /**
     * Collaborators for a story
     * @param  {String/Integer} id [ID or slug for the story]
     * @return {Promise}
     */
    collaborators: function(id) {
      return $http.get("/api/v1/stories/"+ id +"/collaborators").then(function(resp) {
        return resp.data.users;
      });
    },

    /**
     * Restores a story
     * @param  {String/Integer} id [ID or slug for the story]
     * @return {Promise}
     */
    restore: function(id) {
      return $http.put("/api/v1/stories/"+ id +"/restore").then(function(resp) {
        return resp.data.story;
      });
    }
  };
});
