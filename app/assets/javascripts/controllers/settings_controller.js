angular.module("OpenHq").controller("SettingsController", function($scope, $rootScope, $timeout, CurrentUser) {
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

  $scope.updateProfile = function(){
    if ($scope.currentlyUpdating) return;

    $scope.currentlyUpdating = true;
    $scope.showSuccessMessage = false;
    $scope.errors = [];

    CurrentUser.update($scope.user).then(function(resp){
      $scope.currentlyUpdating = false;
      $scope.showSuccessMessage = true;
      $timeout(function(){
        $scope.showSuccessMessage = false;
      }, 5000)

    }, function(resp){
      $scope.currentlyUpdating = false;
      $scope.errors = resp.data.errors;
    });
  };

  $scope.deleteAccount = function(){
    console.log('delete account');
  };
});
