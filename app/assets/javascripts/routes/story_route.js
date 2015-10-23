OpenHq.StoryRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.findRecord('story', params.slug);
  },
  setupController: function(controller, model) {
    controller.set("model", model);
    controller.set("owner", model.get("owner"));
    // Load extra things, tasks + comments
  },
});
