angular.module("OpenHq").factory('apiTokenInterceptor', function() {
    var myInterceptor = {
      request: function(request) {
        request.headers["Authorization"] = 'Token token="'+ window.apiToken +'"';
        return request;
      }
    };
    return myInterceptor;
})
.config(function($httpProvider) {
    $httpProvider.interceptors.push('apiTokenInterceptor');
});
