angular.module("OpenHq").factory("ProjectsRepository", function(Restangular) {
  var allProjects = Restangular.all('projects');

  return {
    all: function(query) {
      return allProjects.getList(query);
    },
    find: function(slug) {
      return Restangular.one("projects", slug).get();
    },
    create: function(params) {
      return allProjects.post({project: params});
    }
  };

});
