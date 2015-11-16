angular.module("OpenHq").controller("MainController", function($scope, $rootScope) {
  $scope.openSearchSidebar = function(){
    $rootScope.$broadcast('search:open');
  };
});
