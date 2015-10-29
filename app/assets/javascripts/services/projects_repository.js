angular.module("OpenHq").factory("projectsRepository", function(Restangular) {
  // return $resource('/api/v1/projects/:projectId', {projectId:'@id'}, {update: {method:'PUT'}});
  return Restangular.all('projects');
});
