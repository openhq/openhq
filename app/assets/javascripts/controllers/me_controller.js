angular.module("OpenHq").controller("MeController", function($scope, TasksRepository, UsersRepository) {
  TasksRepository.me().then(function(tasks) {
    $scope.overdue = tasks.overdue;
    $scope.today = tasks.today;
    $scope.thisWeek = tasks.this_week;
    $scope.other = tasks.other;
  });

  UsersRepository.usersSelectArray().then(function(usa) {
    $scope.allUsers = usa;
  });
});
