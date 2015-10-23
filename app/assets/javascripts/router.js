// For more information see: http://emberjs.com/guides/routing/
Ember.Router.reopen({
  location: 'history'
});

OpenHq.Router.map(function() {
  this.route('projects', {path: "/"});
  this.route('project', {path: "/projects/:slug"});
  this.route('story', {path: "/stories/:slug"});
});
