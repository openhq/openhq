//= require modernizr
//= require jquery
//= require jquery_ujs
//= require angular/angular
//= require angular/angular-route
//= require angular/angular-resource
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

angular.module("OpenHq", ['ngRoute', 'ngAnimate', 'ngResource', 'ngSanitize'])
.config(function($routeProvider, $locationProvider) {
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
});

