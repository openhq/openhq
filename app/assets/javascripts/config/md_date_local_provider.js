angular.module("OpenHq").config(function($mdDateLocaleProvider) {
  $mdDateLocaleProvider.formatDate = function(date) {
    return moment(date).format('Do MMM, YYYY');
  };
});