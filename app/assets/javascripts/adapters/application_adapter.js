// Override the default adapter with the `DS.ActiveModelAdapter` which
// is built to work nicely with the ActiveModel::Serializers gem.
OpenHq.ApplicationAdapter = DS.ActiveModelAdapter.extend({

});
