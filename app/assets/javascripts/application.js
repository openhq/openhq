//= require modernizr
//= require jquery
//= require jquery_ujs
//= require angular/angular
//= require angular/angular-route
//= require angular/angular-animate
//= require angular/angular-aria
//= require angular/angular-material
//= require angularjs/rails/resource
//= require angular/angular-sanitize
//= require angular/ng-file-upload
//= require jquery.timeago
//= require jquery-ui
//# require chosen.jquery
//# require pickadate/picker
//# require pickadate/picker.date
//= require underscore
//# require highlightjs
//= require jquery.atwho
//# require imagesloaded.pkgd.min
//= require mousetrap.min
//= require moment
//= require moment-timezone
//= require message-bus
//= require_tree ./templates
//= require_self
//= require_tree ./config
//= require_tree ./filters
//= require_tree ./directives
//= require_tree ./services
//= require_tree ./controllers

angular.module("OpenHq", ['ngRoute', 'ngAnimate', 'ngSanitize', 'rails', 'ngFileUpload', 'ngMaterial'])
.config(function($routeProvider, $locationProvider, railsSerializerProvider) {

  // App routes
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
  .when('/projects/archived', {
    template: JST['templates/projects/archived'],
    controller: 'ArchivedProjectsController'
  })
  .when('/projects/:slug/manage', {
    template: JST['templates/projects/manage'],
    controller: 'ManageProjectController'
  })
  .when('/projects/:slug', {
    template: JST['templates/projects/show'],
    controller: 'ProjectController'
  })
  .when('/projects/:slug/discussions/new', {
    template: JST['templates/stories/new'],
    controller: 'NewStoryController',
    resolve: { StoryType: function() { return "discussion"; } }
  })
  .when('/projects/:slug/todos/new', {
    template: JST['templates/stories/new'],
    controller: 'NewStoryController',
    resolve: { StoryType: function() { return "todo"; } }
  })
  .when('/projects/:slug/files/new', {
    template: JST['templates/stories/new'],
    controller: 'NewStoryController',
    resolve: { StoryType: function() { return "file"; } }
  })
  .when('/projects/:slug/archived', {
    template: JST['templates/stories/archived'],
    controller: 'ArchivedStoriesController'
  })
  .when('/discussions/:slug', {
    template: JST['templates/stories/show'],
    controller: 'StoryController'
  })
  .when('/discussions/:slug/edit', {
    template: JST['templates/stories/edit'],
    controller: 'EditStoryController'
  })
  .when('/todos/:slug', {
    template: JST['templates/stories/show'],
    controller: 'StoryController'
  })
  .when('/todos/:slug/task/:task_id', {
    template: JST['templates/tasks/show'],
    controller: 'TaskController'
  })
  .when('/todos/:slug/edit', {
    template: JST['templates/stories/edit'],
    controller: 'EditStoryController'
  })
  .when('/files/:slug', {
    template: JST['templates/stories/show'],
    controller: 'StoryController'
  })
  .when('/files/:slug/edit', {
    template: JST['templates/stories/edit'],
    controller: 'EditStoryController'
  })
  .when('/team', {
    template: JST['templates/team/index'],
    controller: 'TeamController'
  })
  .when('/team/new', {
    template: JST['templates/team/new'],
    controller: 'NewTeamInviteController'
  })
  .when('/team/:username', {
    template: JST['templates/team/show'],
    controller: 'ShowTeamController'
  })
  .when('/files', {
    template: JST['templates/files/index'],
    controller: 'FilesController'
  })
  .when('/me', {
    template: JST['templates/me/index'],
    controller: 'MeController'
  })
  .when('/help', {
    template: JST['templates/help/index'],
    controller: 'HelpController'
  })
  .when('/settings', {
    template: JST['templates/settings/index'],
    controller: 'SettingsController'
  })
  .otherwise({
    redirectTo: '/'
  });

  // configure html5 to get links working on jsfiddle
  $locationProvider.html5Mode(true);

  // Don’t convert attributes to camel case
  railsSerializerProvider.underscore(angular.identity).camelize(angular.identity);
});
