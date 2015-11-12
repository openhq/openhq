angular.module("OpenHq").factory("Search", function(railsResourceFactory) {

  return railsResourceFactory({
    url: "/api/v1/search",
    name: "search"
  });

});


