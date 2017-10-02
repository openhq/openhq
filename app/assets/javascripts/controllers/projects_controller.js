angular.module("OpenHq").controller("ProjectsController", function($scope, UsersRepository, Project, CurrentUser, projects) {
  $scope.newProject = new Project();
  $scope.newProjectUsers = {};
  $scope.projects = projects;
  $scope.teamUsers = UsersRepository.all();

  Project.query({archived: true}).then(function(resp){
    $scope.archivedCount = resp.length;
  });

  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  $scope.createProject = function(newProject, newProjectUsers) {
    var selectedUsers = [];

    _.each(newProjectUsers, function(selected, userId) {
      if (selected) selectedUsers.push(userId);
    });

    newProject.user_ids = selectedUsers;

    newProject.create().then(function(project) {
      $scope.projects.push(project);
      $scope.newProject = new Project();
    });
  };
});
