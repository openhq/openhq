OpenHq.StoriesRoute = Ember.Route.extend({
  model: function(params) {
    console.log("Loading story", params);
    return this.store.query('story', {project_id: params.projectId});
  }
});
