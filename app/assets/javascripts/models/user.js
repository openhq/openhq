OpenHq.User = DS.Model.extend({
  displayName: DS.attr("string"),
  firstName: DS.attr("string"),
  lastName: DS.attr("string"),
  username: DS.attr("string"),
  email: DS.attr("string"),
  notificationFrequency: DS.attr("string"),
  lastNotifiedAt: DS.attr("date"),
  jobTitle: DS.attr("string"),
  avatarUrl: DS.attr("string"),
  createdAt: DS.attr("date"),
  updatedAt: DS.attr("date"),
  admin: DS.attr("boolean", {defaultValue: false}),
});
