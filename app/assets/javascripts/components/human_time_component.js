OpenHq.HumanTimeComponent = Ember.Component.extend({
  tagName: "abbr",
  classNames: ["timeago"],
  attributeBindings: ["time:title"],
  afterRenderEvent: function() {
    $(this.element).timeago();
  },
});
