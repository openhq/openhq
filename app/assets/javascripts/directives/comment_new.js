angular.module("OpenHq").directive("commentNew", function($rootScope, Comment) {
  return {
    restrict: "E",
    scope: {
      currentUser: '=',
      commentableType: '=',
      commentableId: '=',
    },

    template: JST['templates/directives/comment_new'],

    controller: function($scope) {
      $scope.comment = new Comment({attachment_ids: "" });
      $scope.fileUploads = [];
      $scope.currentlyUploading = 0;

      // Creates a new comment
      $scope.createComment = function(comment) {
        comment.commentable_type = $scope.commentableType;
        comment.commentable_id = $scope.commentableId;

        comment.create().then(function(resp) {
          $scope.comment = new Comment({attachment_ids: "" });
          $scope.fileUploads = [];

          $rootScope.$broadcast('comment:created', resp);
        });
      };
    }
  };
});
