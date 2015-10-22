// For more information see: http://emberjs.com/guides/routing/
Ember.Router.reopen({
  location: 'history'
});

OpenHq.Router.map(function() {
  this.resource('projects', {path: "/"});
  this.resource('stories', {path: "/projects/:projectId/stories"});
});
