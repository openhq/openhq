angular.module("OpenHq").factory("ProjectsRepository", function($http) {
  return {
    /**
     * Restores a project
     * @param  {String/Integer} id [ID or slug for the story]
     * @return {Promise}
     */
    restore: function(id) {
      return $http.put("/api/v1/projects/"+ id +"/restore").then(function(resp) {
        return resp.data.project;
      });
    }
  };
});
