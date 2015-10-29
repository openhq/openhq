// Override the default adapter with the `DS.ActiveModelAdapter` which
// is built to work nicely with the ActiveModel::Serializers gem.
var underscore = Ember.String.underscore;

OpenHq.ApplicationAdapter = DS.JSONAPIAdapter.extend({
  namespace: 'api/v1',
  headers: {
    'Authorization': 'Token token="'+window.apiToken+'"',
  },
});

OpenHq.ApplicationSerializer = DS.JSONAPISerializer.extend({
  keyForAttribute: function(attr) {
    return underscore(attr);
  },

  keyForRelationship: function(rawKey) {
    return underscore(rawKey);
  }
});
