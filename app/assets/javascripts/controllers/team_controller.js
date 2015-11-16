angular.module("OpenHq").controller("TeamController", function($scope, UsersRepository) {
  $scope.teamUsers = UsersRepository.all();

  UsersRepository.invitedUsers().then(function(users) {
    $scope.invitedUsers = users;
  });
});
