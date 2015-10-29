angular.module("OpenHq").factory('apiTokenInterceptor', function() {
    return {
      request: function(request) {
        request.headers["Authorization"] = 'Token token="'+ window.apiToken +'"';
        return request;
      }
    };
})
.config(function($httpProvider) {
    $httpProvider.interceptors.push('apiTokenInterceptor');
});
