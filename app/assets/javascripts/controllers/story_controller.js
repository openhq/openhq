angular.module("OpenHq").controller("StoryController", function($scope, $rootScope, $routeParams, $http, Task, AttachmentsRepository, StoriesRepository, Story, CurrentUser, Comment, Upload) {
  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  StoriesRepository.find($routeParams.slug).then(function(story) {
    $scope.newComment = new Comment({story_id: story.id });
    $scope.newTask = new Task({story_id: story.id, assigned_to: 0 });
    $scope.story = story;
  });

  StoriesRepository.collaborators($routeParams.slug).then(function(collaborators) {
    $scope.collaborators = collaborators;
  });

  $scope.createComment = function(newComment) {
    newComment.create().then(function(resp) {
      console.log("comment created", resp);
      $scope.story.comments.push(resp);
    });
  };

  $scope.createTask = function(newTask) {
    newTask.create().then(function(resp) {
      $scope.story.tasks.push(resp);
      $scope.newTask = new Task({story_id: $scope.story.id, assigned_to: 0});
    });
  };

  $scope.upload = function($files) {
    if (!$files || !$files.length) {
      console.error("No files found");
      return;
    }

    console.log("Uploading files...", $files);

    _.each($files, function(file) {
      if (!file.$error) {
        AttachmentsRepository.presignedUrl(file).then(function(awsData) {
          console.log("Upload start", awsData.upload_url, file.name, file.type);

          // $http({
          //   url: awsData.upload_url,
          //   method: "PUT",
          //   data: file,
          //   headers: {
          //     'Content-Type': file.type
          //   }
          // }).then(function(resp) {
          //   console.log("Upload success", resp);

          //   var attachmentData = {
          //     file_name: file.name,
          //     file_size: file.size,
          //     content_type: file.type,
          //     file_path: awsData.file_path,
          //   };

          //   console.log("attachmentData", attachmentData);
          // }, function(err) {
          //   console.error("Upload failed", err, arguments);
          // });

          Upload.http({
              url: awsData.upload_url,
              method: "PUT",
              data: file,
              headers: {
                'Content-Type': file.type
              }
          }).progress(function (evt) {
            console.log("Upload progress", evt);
              // var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
              // $scope.log = 'progress: ' + progressPercentage + '% ' +
              //             evt.config.data.file.name + '\n' + $scope.log;
          }).success(function (data, status, headers, config) {
            console.log("Upload success", arguments);

            var attachmentData = {
              file_name: file.name,
              file_size: file.size,
              content_type: file.type,
              file_path: awsData.file_path,
            };

            console.log("attachmentData", attachmentData);
            // $timeout(function() {
            //     $scope.log = 'file: ' + config.data.file.name + ', Response: ' + JSON.stringify(data) + '\n' + $scope.log;
            // });
          }); // upload

        }); // presignedUrl
      }
    });
  };

  $rootScope.$on('task:deleted', function(_ev, task_id){
    $scope.story.tasks = _.reject($scope.story.tasks, function(task){
      return task.id == task_id;
    });
  });
});
