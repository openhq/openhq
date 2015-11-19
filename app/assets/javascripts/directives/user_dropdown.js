angular.module("OpenHq").directive("userDropdown", function(CurrentUser) {
  return {
    restrict: "E",
    scope: {},
    template: JST['templates/directives/user_dropdown'],
    controller: function($scope, $rootScope){
      $scope.showing = false;
      CurrentUser.get(function(user){
        $scope.user = user;
      });

      $scope.toggleShowing = function(){
        var currently_showing = angular.copy($scope.showing);
        $rootScope.$broadcast('dialogs:close');
        if (!currently_showing) { $scope.showing = true; }
      };

      $rootScope.$on("dialogs:close", function() {
        $scope.showing = false;
      });

      $scope.stopProp = function($event) {
        $event.stopPropagation();
      };

      $scope.signOut = function() {
        console.log('signin out, braw?');
      };
    }
  }
});