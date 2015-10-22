OpenHq.HumanTimeComponent = Ember.Component.extend({
  tagName: "abbr",
  classNames: ["timeago"],
  attributeBindings: ["time:title"],
  afterRenderEvent: function() {
    $(this.element).timeago();
    console.log("human time rendered", this.get("time"));
  },
});


// <abbr class="timeago" title="October 19, 2015 11:20">3 days ago</abbr>
