//= require modernizr
//= require jquery
//= require jquery_ujs
//= require angular/angular
//= require angular/angular-route
//= require angularjs/rails/resource
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
//= require moment
//= require moment-timezone
//= require message-bus
//= require_tree ./templates
//= require_self
//= require_tree ./filters
//= require_tree ./directives
//= require_tree ./services
//= require_tree ./controllers

angular.module("OpenHq", ['ngRoute', 'ngAnimate', 'rails', 'ngSanitize'])
.config(function($routeProvider, $locationProvider, railsSerializerProvider) {
  $routeProvider
  .when('/', {
    template: JST['templates/projects/index'],
    controller: 'ProjectsController',
    resolve: {
      projects: function(Project) {
        return Project.query();
      }
    }
  })
  .when('/projects/:slug', {
    template: JST['templates/projects/show'],
    controller: 'ProjectController'
  })
  .when('/projects/:slug/stories/new', {
    template: JST['templates/stories/new'],
    controller: 'NewStoryController'
  })
  .when('/stories/:slug', {
    template: JST['templates/stories/show'],
    controller: 'StoryController'
  })
  .otherwise({
    redirectTo: '/'
  });

  // configure html5 to get links working on jsfiddle
  $locationProvider.html5Mode(true);

  // Don’t convert attributes to camel case
  railsSerializerProvider.underscore(angular.identity).camelize(angular.identity);

});
