angular.module("OpenHq").controller("NewTeamInviteController", function($scope, $location, Project, UsersRepository) {

  $scope.invite = {};
  $scope.selectedProjects = {};

  Project.query().then(function(projects) {
    $scope.projects = projects;
  });

  $scope.sendInvite = function(user, selectedProjects) {
    user.project_ids = [];

    _.each(selectedProjects, function(selected, projectId) {
      if (selected) user.project_ids.push(projectId);
    });

    UsersRepository.invite(user).then(function(resp) {
      $location.url("/team");
    });
  };
});
