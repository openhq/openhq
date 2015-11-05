angular.module("OpenHq").factory("ProjectsRepository", function($http, Project) {
  return {
    /**
     * Archived stories for a project
     * @param  {String/Integer} id [ID or slug for the story]
     * @return {Promise}
     */
    archived_stories: function(id) {
      return $http.get("/api/v1/projects/"+ id +"/archived").then(function(resp) {
        return resp.stories;
      });
    }
  };
});
