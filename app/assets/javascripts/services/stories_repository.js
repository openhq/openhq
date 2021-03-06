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
          var task = new Task(taskData);
          task.due_at = task.due_at ? new Date(task.due_at) : "";

          return task;
        });

        // Wrap all comments in models
        story.comments = story.comments.map(function(commentData) {
          return new Comment(commentData);
        });

        story.comments = story.comments.reverse();
        story.attachments = story.attachments.reverse();

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
