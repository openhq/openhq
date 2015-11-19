angular.module("OpenHq").controller("SettingsController", function($scope, $rootScope, CurrentUser) {
  $scope.onProfilePage = true;
  $scope.onPasswordPage = false;
  $scope.current_password = "";

  $scope.notificationFrequencies = [
    ['ASAP', 'asap'],
    ['Daily', 'daily'],
    ['Never', 'never']
  ];

  CurrentUser.get(function(user){
    $scope.user = user;
  });

  $scope.updateProfile = function(){
    CurrentUser.update($scope.user).then(function(resp){
      console.log('updated', resp);
    }, function(resp){
      console.log('failed', resp);
    });
  };

  $scope.deleteAccount = function(){
    console.log('delete account');
  };
});
