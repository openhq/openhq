angular.module("OpenHq").config(function($mdDateLocaleProvider) {
  $mdDateLocaleProvider.formatDate = function(date) {
    return date ? moment(date).format('Do MMM, YYYY') : "";
  };
  $mdDateLocaleProvider.parseDate = function(dateString) {
    var m = moment(dateString, 'Do MMM, YYYY', true);
    return m.isValid() ? m.toDate() : "";
  };
});