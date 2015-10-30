angular.module("OpenHq").factory("Project", function(railsResourceFactory) {

  return railsResourceFactory({
    url: "/api/v1/projects",
    name: "project"
  });

});


