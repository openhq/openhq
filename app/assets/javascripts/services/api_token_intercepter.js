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
    // Ensure all angular requests use api token
    $httpProvider.interceptors.push('apiTokenInterceptor');

    // Ensure third party plugins use api token if posting to self
    $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
      if (options.url[0] === "/") {
        if (!options.beforeSend) {
          options.beforeSend = function (xhr) {
            xhr.setRequestHeader('Authorization', 'Token token="'+ window.apiToken +'"');
          }
        }
      }
    });
});
