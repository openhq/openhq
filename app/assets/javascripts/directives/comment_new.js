angular.module("OpenHq").directive("commentNew", function($rootScope, Comment, AttachmentsRepository, Attachment, Upload) {
  return {
    restrict: "E",
    scope: {
      currentUser: '=',
      commentableType: '=',
      commentableId: '=',
      storyId: '=',
    },

    template: JST['templates/directives/comment_new'],

    controller: function($scope) {
      $scope.comment = new Comment({attachment_ids: "" });
      $scope.fileUploads = [];
      $scope.currentlyUploading = 0;

      // Creates a new comment
      $scope.createComment = function(ev, comment) {
        ev.preventDefault();

        comment.commentable_type = $scope.commentableType;
        comment.commentable_id = $scope.commentableId;
        comment.story_id = $scope.storyId;

        comment.create().then(function(resp) {
          $scope.comment = new Comment({attachment_ids: ""});
          $scope.fileUploads = [];

          $rootScope.$broadcast('comment:created', resp);
        });
      };

      // Uploads a new file
      $scope.upload = function($files) {
        if (!$files || !$files.length) {
          console.error("No files found");
          return;
        }

        _.each($files, function(file) {
          if (!file.$error) {
            $scope.currentlyUploading++;

            AttachmentsRepository.presignedUrl(file).then(function(awsData) {
              console.log("Upload start", awsData.upload_url, file.name, file.type);

              $scope.fileUploads.push(file);

              Upload.http({
                  url: awsData.upload_url,
                  method: "PUT",
                  data: file,
                  headers: {
                    'Content-Type': file.type
                  }
              }).progress(function (evt) {
                  var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
                  file.uploadProgress = progressPercentage;
              }).success(function (data, status, headers, config) {
                console.log("Upload success", arguments);
                $scope.currentlyUploading--;

                file.uploadComplete = true;

                var attachment = new Attachment({
                  story_id: $scope.storyId,
                  file_name: file.name,
                  file_size: file.size,
                  content_type: file.type,
                  file_path: awsData.file_path,
                });

                attachment.create().then(function(attachment) {
                  console.log("Actually created", attachment);
                  // $scope.story.attachments.push(attachment);

                  $scope.comment.attachment_ids += attachment.id + ",";
                });
              }); // upload

            }); // presignedUrl
          }
        });
      };
    }
  };
});
