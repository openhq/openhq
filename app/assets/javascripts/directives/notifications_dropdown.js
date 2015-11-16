angular.module("OpenHq").directive("notificationsDropdown", function(Notification) {
  return {
    restrict: "E",
    template: JST['templates/directives/notifications_dropdown'],

    controller: function($scope, $rootScope){
      $scope.showing = false;
      $scope.newCount = 0;
      $scope.notifications = {};

      Notification.query().then(function(notifications){
        $scope.notifications = notifications;
        $scope.updateNewCount();
      });

      $scope.updateNewCount = function(){
        $scope.newCount = _.reject($scope.notifications, function(n) {
          return n.seen;
        }).length;
      };

      $scope.toggleShowing = function(){
        $scope.showing = !$scope.showing;
      };

      /**
       * Clicking outside the dropdown closes it
       */
      $(document).on("click", function() {
        $scope.$apply(function(){
          $scope.showing = false;
        });
      });
      $(document).on("click", "notifications-dropdown", function(ev) {
        ev.stopPropagation();
      });
    }
  }
});