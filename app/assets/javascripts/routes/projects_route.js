OpenHq.ProjectsRoute = Ember.Route.extend({
  model: function() {
    return this.store.findAll('project');
  }
});
