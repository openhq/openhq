// Override the default adapter with the `DS.ActiveModelAdapter` which
// is built to work nicely with the ActiveModel::Serializers gem.
OpenHq.ApplicationAdapter = DS.JSONAPIAdapter.extend({
  namespace: 'api/v1',
  headers: {
    'Authorization': 'Token token="'+window.apiToken+'"',
  },
});
