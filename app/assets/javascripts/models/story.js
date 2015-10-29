OpenHq.Story = DS.Model.extend({
  name: DS.attr("string"),
  slug: DS.attr("string"),
  description: DS.attr("string"),
  markdown: DS.attr("string"),
  owner: DS.belongsTo('user'),
  createdAt: DS.attr("date"),
  updatedAt: DS.attr("date"),
  deletedAt: DS.attr("date"),
  project: DS.belongsTo('project'),
  team: DS.belongsTo('team'),
});
