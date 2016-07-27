angular.module("OpenHq").controller("StoryController", function($scope, $rootScope, $routeParams, $http, $filter, $location, Task, TasksRepository, StoriesRepository, Story, AttachmentsRepository, Attachment, CurrentUser, Comment, Upload, ConfirmDialog) {

  // Sets the current user
  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  // Gets the story and sets up the page
  StoriesRepository.find($routeParams.slug).then(function(story) {
    $scope.newTask = new Task({story_id: story.id, assigned_to: 0 });
    $scope.story = story;

    $scope.story.hasCompletedTasks = $filter('completedTasks')($scope.story.tasks).length > 0;
    $scope.story.showingCompletedTasks = false;

    if (_.contains(['discussion', 'file'], story.story_type)) {
      $scope.showingDescription = true;
    }

    if (story.story_type === "todo") $scope.showingTodoList = true;
  });

  // Sets collaborators
  StoriesRepository.collaborators($routeParams.slug).then(function(collaborators) {
    $scope.collaborators = collaborators;
  });

  // When a task is marked as complete
  $rootScope.$on('story:taskCompleted', function(){
    $scope.story.hasCompletedTasks = $filter('completedTasks')($scope.story.tasks).length > 0;
  });

  // Calculates the task completion percentage
  $scope.taskCompletionPercentage = function() {
    if (! $scope.story) return 0; // Story not loaded yet
    if ($scope.story.tasks.length === 0) return 0; // Protect zero division error

    var percent = $filter('completedTasks')($scope.story.tasks).length / $scope.story.tasks.length * 100;
    return Math.round(percent);
  };


  // Creates a new task
  $scope.createTask = function(newTask) {
    newTask.create().then(function(resp) {
      resp.due_at = resp.due_at ? new Date(resp.due_at) : "";
      $scope.story.tasks.push(resp);
      $scope.newTask = new Task({story_id: $scope.story.id, assigned_to: 0});
    });
  };

  // Deletes a task from the list
  $rootScope.$on('task:deleted', function(_ev, task_id){
    $scope.story.tasks = _.reject($scope.story.tasks, function(task){
      return task.id == task_id;
    });
  });

  $rootScope.$on('comment:deleted', function(_ev, comment){
    if (comment.commentable_type === "Story" && comment.commentable_id === $scope.story.id) {
      $scope.story.comments = _.reject($scope.story.comments, function(c) {
        return c.id == comment.id;
      });
    }
  });

  $rootScope.$on('comment:created', function(_ev, comment) {
    if (comment.commentable_type === "Story" && comment.commentable_id === $scope.story.id) {
      $scope.story.comments.push(comment);
    }
  });

  // Deletes all completed tasks
  $scope.deleteCompletedTasks = function() {
    ConfirmDialog.show('Delete Completed Tasks', 'Are you sure you want to delete all the completed tasks?').then(function(){
      TasksRepository.deleteCompleted($routeParams.slug).then(function(){
        // remove any completed tasks from the collection
        $scope.story.tasks = _.where($scope.story.tasks, {completed: false});
        $scope.story.hasCompletedTasks = false;
        $scope.story.showingCompletedTasks = false;
      });
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
              story_id: $scope.story.id,
              file_name: file.name,
              file_size: file.size,
              content_type: file.type,
              file_path: awsData.file_path,
            });

            attachment.create().then(function(attachment) {
              console.log("Actually created", attachment);
              $scope.story.attachments.push(attachment);

              $scope.newComment.attachment_ids += attachment.id + ",";
            });
          }); // upload

        }); // presignedUrl
      }
    });
  };

  // Archive the story
  $scope.archiveStory = function() {
    ConfirmDialog.show('Archive Story', 'Are you sure you want to archive this story?').then(function(){
      $scope.story.delete().then(function(){
        // TODO: add a notification
        $location.url('/projects/'+$scope.story.project.slug);
      });
    });
  };

});
