angular.module("OpenHq").controller("MainController", function($scope, $rootScope) {
  $scope.closeDialogs = function(){
    $rootScope.$broadcast("dialogs:close");
  };
});
