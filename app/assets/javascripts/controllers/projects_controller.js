OpenHq.ProjectsController = Ember.Controller.extend({
  actions: {
    createProject: function() {
      if (this.get("projectName").length < 1) return;

      console.log("Create project", this.get("projectName"));

      var project = this.store.createRecord('project', {
        name: this.get("projectName")
      });

      project.save();
    }
  }
});
