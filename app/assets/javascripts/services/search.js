angular.module("OpenHq").factory("Search", function($http) {
  return {
    find: function(term, opts) {
      opts = opts || {};
      _.defaults(opts, {
        page: 1,
        limit: 20
      });

      return $http({
        method: "GET",
        url: "/api/v1/search",
        params: {
          term: term,
          page: opts.page,
          limit: opts.limit
        }
      }).then(function(resp){
        return resp.data;
      });
    }
  }
});


