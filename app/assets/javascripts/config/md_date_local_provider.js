angular.module("OpenHq").config(function($mdDateLocaleProvider) {
  $mdDateLocaleProvider.formatDate = function(date) {
    return date ? moment(date).format('Do MMM, YYYY') : "";
  };
});