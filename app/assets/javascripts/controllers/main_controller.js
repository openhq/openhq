angular.module("OpenHq").controller("MainController", function($scope, $rootScope) {

  $scope.closeDialogs = function(){
    $rootScope.$broadcast("dialogs:close");
  };

  $scope.openSearchSidebar = function($event){
    $event.stopPropagation();
    $rootScope.$broadcast('search:open');
  };

});
