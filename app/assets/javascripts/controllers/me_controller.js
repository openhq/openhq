angular.module("OpenHq").controller("MeController", function($scope, TasksRepository) {
  TasksRepository.me().then(function(tasks) {
    $scope.overdue = tasks.overdue;
    $scope.today = tasks.today;
    $scope.thisWeek = tasks.this_week;
    $scope.other = tasks.other;
  });
});
