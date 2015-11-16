angular.module("OpenHq").controller("TeamController", function($scope, UsersRepository) {
  $scope.teamUsers = UsersRepository.all();
  UsersRepository.invitedUsers().then(function(users) {
    console.log("Got invited userss", users);
    $scope.invitedUsers = users;
  });
});
