angular.module("OpenHq").controller("TeamController", function($scope, UsersRepository) {
  $scope.teamUsers = UsersRepository.all();
});
