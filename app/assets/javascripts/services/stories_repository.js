angular.module("OpenHq").factory("StoriesRepository", function(Restangular) {
  var allStories = Restangular.all('stories');

  return {
    all: function(query) {
      return allStories.getList(query);
    },
    find: function(slug) {
      return Restangular.one("stories", slug).get();
    },
    create: function(params) {
      return allStories.post({story: params});
    }
  };
});
