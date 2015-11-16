angular.module("OpenHq").factory("Search", function($http, $q) {
  return {
    find: function(term, opts) {
      opts = opts || {};
      _.defaults(opts, {
        page: 1,
        limit: 3
      });

      // Deferred value to allow us to abort the request
      var dfd = $q.defer();
      var request = $http({
        method: "GET",
        url: "/api/v1/search",
        timeout: dfd.promise,
        params: {
          term: term,
          page: opts.page,
          limit: opts.limit
        }
      });

      // success/fail responses from the request
      var promise = request.then(
        function(resp) { return resp.data; },
        function() { return $q.reject('cancelled search request'); }
      );

      // adding an abort method to the promise
      promise.abort = function() {
        dfd.resolve();
      };

      // clean things up when the promise is resolved
      promise.finally(function() {
        promise.abort = angular.noop;
        dfd = request = promise = null;
      });

      return promise;
    }
  }
});


