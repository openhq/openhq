OpenHq.ProjectRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.findRecord("project", params.slug);
  },
  setupController: function(controller, model) {
    console.log("setup controller", model.get("slug"));
    var stories = this.store.query('story', { project_id: model.get("slug") });
    controller.set('project', model);
    controller.set('stories', stories);
  }
});
