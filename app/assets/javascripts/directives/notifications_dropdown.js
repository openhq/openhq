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
      });

      // when notifications update, update the new count
      $scope.$watch('notifications', function(){
        $scope.newCount = _.reject($scope.notifications, function(n) {
          return n.seen;
        }).length;
      });

      $scope.$watch('showing', function(){
        if ($scope.newCount > 0 && !$scope.showing) {
          $scope.newCount = 0;
          _.each($scope.notifications, function(n){
            n.seen = true;
          });
        }
      });

      $scope.toggleShowing = function(){
        $scope.showing = !$scope.showing;
        if ($scope.newCount > 0) $scope.markAllAsSeen();
      };

      $scope.markAllAsSeen = function(){
        NotificationsRepository.markAsSeen(_.map($scope.notifications, function(n){
          return n.id;
        }));
      };

      // New notification has come in
      $rootScope.$on('notification:new', function(_ev, data){
        NotificationsRepository.find(data.id).then(function(notification){
          $scope.notifications.unshift(notification);
          $scope.newCount += 1;
        });
      });

      $rootScope.$on("dialogs:close", function() {
        $scope.showing = false;
      });

      $scope.stopProp = function($event) {
        $event.stopPropagation();
      };

    }
  }
});