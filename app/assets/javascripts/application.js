//= require modernizr
//= require jquery
//= require jquery_ujs
//= require angular/angular
//= require angular/angular-route
//= require angular/restangular
//= require angular/angular-animate
//= require angular/angular-sanitize
//= require jquery.timeago
//# require jquery-ui
//# require chosen.jquery
//# require pickadate/picker
//# require pickadate/picker.date
//= require underscore
//# require highlightjs
//# require jquery.atwho
//# require imagesloaded.pkgd.min
//# require mousetrap.min
//= require message-bus
//= require_tree ./templates
//= require_self
//= require_tree ./directives
//= require_tree ./services
//= require_tree ./controllers

angular.module("OpenHq", ['ngRoute', 'ngAnimate', 'restangular', 'ngSanitize'])
.config(function($routeProvider, $locationProvider, RestangularProvider) {
  $routeProvider
  .when('/', {
    template: JST['templates/projects/index'],
    controller: 'ProjectsController',
    resolve: {
      projects: ['$route', function($route) {
        return {};
      }]
    }
  })
  .otherwise({
    redirectTo: '/'
  });

  // configure html5 to get links working on jsfiddle
  $locationProvider.html5Mode(true);

  RestangularProvider.setBaseUrl('/api/v1');

  RestangularProvider.addResponseInterceptor(function(data, operation, modelName, url, response, deferred) {
    var singular = modelName,
        objs;

    if (modelName[modelName.length - 1] === "s") {
      singular = modelName.substring(0, modelName.length - 1);
    }

    objs = data[singular] || data[modelName];
    console.log("Restangular extract", singular, modelName, objs);

    deferred.resolve(objs);
    return objs;
  });

});
