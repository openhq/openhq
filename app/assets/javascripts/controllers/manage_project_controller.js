angular.module("OpenHq").controller("ManageProjectController", function($scope, $rootScope, $routeParams, $location, Project, ConfirmDialog, UsersRepository, CurrentUser) {
  $scope.teamUsers = UsersRepository.all();
  $scope.projectUsers = {};

  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  Project.get($routeParams.slug).then(function(project) {
    $scope.staticProject = angular.copy(project);
    $scope.project = project;

    project.users.forEach(function(user) {
      $scope.projectUsers[user.id] = true;
    });
  });

  $scope.archiveProject = function() {
    ConfirmDialog.show('Archive Project', 'Are you sure you want to archive this project?').then(function(){
      $scope.project.delete().then(function(resp){
        // TODO: add a notification
        $location.url('/');
      });
    });
  };

  $scope.updateProject = function(project, projectUsers) {
    var selectedUsers = [];

    _.each(projectUsers, function(selected, userId) {
      if (selected) selectedUsers.push(userId);
    });

    project.user_ids = selectedUsers;

    project.save().then(function(resp) {
      $location.url('/projects/'+resp.slug);
    });
  };
});
