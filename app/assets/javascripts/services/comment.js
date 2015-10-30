angular.module("OpenHq").factory("Comment", function(railsResourceFactory) {

  return railsResourceFactory({
    url: "/api/v1/comments",
    name: "comment"
  });

});


