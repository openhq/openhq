angular.module("OpenHq").factory('ConfirmDialog', function($mdDialog) {
    return {
      show: function(title, content) {
        var confirm = $mdDialog.confirm()
          .title(title)
          .content(content)
          .ok('Yes, do it!')
          .cancel('Cancel');

        return $mdDialog.show(confirm)
      }
    };
});
