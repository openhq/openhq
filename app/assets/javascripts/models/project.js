OpenHq.Project = DS.Model.extend({
  name: DS.attr("string"),
  slug: DS.attr("string"),
  owner: DS.belongsTo('user'),
  createdAt: DS.attr("date"),
  updatedAt: DS.attr("date"),
  deletedAt: DS.attr("date"),
  team: DS.belongsTo('team'),
});
