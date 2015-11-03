angular.module("OpenHq").controller("ProjectsController", function($scope, UsersRepository, Project, projects) {
  $scope.newProject = new Project();
  $scope.newProjectUsers = {};
  $scope.projects = projects;
  $scope.teamUsers = UsersRepository.all();

  $scope.createProject = function(newProject, newProjectUsers) {
    var selectedUsers = [];

    _.each(newProjectUsers, function(selected, userId) {
      if (selected) selectedUsers.push(userId);
    });

    newProject.user_ids = selectedUsers;

    newProject.create().then(function(project) {
      $scope.projects.push(project);
    });
  };
});
