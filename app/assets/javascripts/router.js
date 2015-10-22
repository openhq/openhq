// For more information see: http://emberjs.com/guides/routing/
Ember.Router.reopen({
  location: 'history'
});

OpenHq.Router.map(function() {
  this.resource('projects', {path: "/"});
  this.route('project', {path: "/projects/:slug"})
  this.route('story', {path: "/projects/:project_slug/stories/:slug"})
});
