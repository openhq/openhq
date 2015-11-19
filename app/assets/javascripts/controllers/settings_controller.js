angular.module("OpenHq").controller("SettingsController", function($scope, $rootScope, CurrentUser, ConfirmDialog) {
  $scope.onProfilePage = true;
  $scope.onPasswordPage = false;
  $scope.currentlyUpdating = false;
  $scope.errors = [];
  $scope.showSuccessMessage = false;

  $scope.notificationFrequencies = [
    ['ASAP', 'asap'],
    ['Daily', 'daily'],
    ['Never', 'never']
  ];

  CurrentUser.get(function(user){
    $scope.user = user;
  });

  $scope.showProfilePage = function(){
    $scope.errors = [];
    $scope.showSuccessMessage = false;
    $scope.onProfilePage = true;
    $scope.onPasswordPage = false;
  };

  $scope.showPasswordPage = function(){
    $scope.errors = [];
    $scope.showSuccessMessage = false;
    $scope.onProfilePage = false;
    $scope.onPasswordPage = true;
  };

  $scope.updateProfile = function(){
    if ($scope.currentlyUpdating) return;

    $scope.currentlyUpdating = true;
    $scope.showSuccessMessage = false;
    $scope.errors = [];

    CurrentUser.update($scope.user).then(function(resp){
      $scope.currentlyUpdating = false;
      $scope.showSuccessMessage = true;

    }, function(resp){
      $scope.currentlyUpdating = false;
      $scope.errors = resp.data.errors;
    });
  };

  $scope.updatePassword = function(){
    if ($scope.currentlyUpdating) return;

    $scope.currentlyUpdating = true;
    $scope.showSuccessMessage = false;
    $scope.errors = [];

    CurrentUser.updatePassword($scope.user).then(function(resp){
      $scope.currentlyUpdating = false;
      $scope.showSuccessMessage = true;

    }, function(resp){
      $scope.currentlyUpdating = false;
      $scope.errors = resp.data.errors;
    });
  };

  $scope.deleteAccount = function(){
    ConfirmDialog.show('Delete Account', 'Are you sure you want to delete your account?').then(function(){
      CurrentUser.deleteAccount($scope.user.current_password).then(function(resp){
        // TODO: sign out when deleting the count and just use $location.url('/') here
        window.location.replace('/sign_out');

      }, function(resp){
        $scope.errors = [{field: "Password", errors: ["Your current password was incorrect"]}];
      });
    });
  };
});
