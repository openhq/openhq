angular.module("OpenHq").controller("SettingsController", function($scope, $rootScope, $timeout, CurrentUser, ConfirmDialog) {
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

  // TODO: actually delete account
  $scope.deleteAccount = function(){
    ConfirmDialog.show('Delete Account', 'Are you sure you want to delete your account?').then(function(){
      ConfirmDialog.show('Seriously Though.', 'You won\'t be able to get it back').then(function(){
        console.log('delete account');
      });
    });
  };

  // TODO: update the password
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
});
