angular.module("OpenHq").factory('apiTokenInterceptor', function() {
    return {
      request: function(request) {
        if (request.url.match(/amazonaws\.com/)) {
          return request;
        }

        request.headers["Authorization"] = 'Token token="'+ window.apiToken +'"';
        return request;
      }
    };
})
.config(function($httpProvider) {
    $httpProvider.interceptors.push('apiTokenInterceptor');
});
