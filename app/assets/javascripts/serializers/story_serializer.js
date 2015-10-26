OpenHq.StorySerializer = DS.ActiveModelSerializer.extend({
  modelNameFromPayloadKey: function(key) {
    if (key === "owner" || key === "owners") return "user";

    return this._super(key);
  },
});
