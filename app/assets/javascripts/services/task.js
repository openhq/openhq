angular.module("OpenHq").factory("Task", function(railsResourceFactory) {

  return railsResourceFactory({
    url: "/api/v1/tasks",
    name: "task"
  });

});
