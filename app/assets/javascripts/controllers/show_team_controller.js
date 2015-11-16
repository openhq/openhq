angular.module("OpenHq").controller("ShowTeamController", function($scope, $routeParams, UsersRepository) {
  $scope.username = $routeParams.username;
  $scope.teamUsers = UsersRepository.all();
});
