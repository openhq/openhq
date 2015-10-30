angular.module("OpenHq").factory("Story", function(railsResourceFactory) {

  return railsResourceFactory({
    url: "/api/v1/stories",
    name: "story",
    pluralName: "stories"
  });

});
