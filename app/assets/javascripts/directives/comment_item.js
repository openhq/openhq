angular.module("OpenHq").directive("commentItem", function($rootScope, Comment, ConfirmDialog) {
  return {
    restrict: "E",
    scope: {
      comment: '=',
      currentUser: '=',
    },
    template: JST['templates/directives/comment_item'],
    controller: function($scope) {
      // Toggle comment editing
      $scope.toggleEditComment = function(comment) {
        if (comment.editing) return comment.editing = false;
        comment.editing = true;
      };

      // Updates a comment
      $scope.updateComment = function(ev, comment) {
        ev.preventDefault();
        comment.update().then(function(resp) {
          comment.editing = false;
        });
      };

      // Deletes a comment
      $scope.deleteComment = function(comment) {
        ConfirmDialog.show('Delete comment', 'Are you sure you want to delete this comment?').then(function(){
          comment.delete().then(function() {
            $rootScope.$broadcast('comment:deleted', comment);
          });
        });
      };

    }
  };
});
