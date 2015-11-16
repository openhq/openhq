angular.module("OpenHq").directive("notificationsDropdown", function(NotificationsRepository) {
  return {
    restrict: "E",
    template: JST['templates/directives/notifications_dropdown'],

    controller: function($scope, $rootScope, $timeout){
      $scope.showing = false;
      $scope.newCount = 0;
      $scope.notifications = {};

      // Load up all the notifications
      NotificationsRepository.recent().then(function(notifications){
        // remove any notifications where the project/story has been archived
        $scope.notifications = _.reject(notifications, function(n) {
          if (n.notifiable_type == "Project") {
            return _.isNull(n.project);
          } else {
            return (_.isNull(n.project) || _.isNull(n.story));
          }
        });

        $scope.updateNewCount();
      });

      $scope.updateNewCount = function(){
        $scope.newCount = _.reject($scope.notifications, function(n) {
          return n.seen;
        }).length;
      };

      $scope.toggleShowing = function(){
        $scope.showing = !$scope.showing;
        if ($scope.newCount > 0) $scope.markAllAsSeen();
      };

      $scope.$watch('showing', function(){
        if ($scope.newCount > 0 && !$scope.showing) {
          $scope.newCount = 0;
          _.each($scope.notifications, function(n){
            n.seen = true;
          });
        }
      });

      $scope.markAllAsSeen = function(){
        NotificationsRepository.markAllAsSeen();
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