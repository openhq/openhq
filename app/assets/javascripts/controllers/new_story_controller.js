angular.module("OpenHq").controller("NewStoryController", function($scope, $rootScope, $routeParams, $location, Story, Project, Task, CurrentUser, StoryType, AttachmentsRepository, Attachment, Upload) {
  $scope.projectId = $routeParams.slug;

  // Base story
  $scope.story = new Story({project_id: $scope.projectId, story_type: StoryType});
  $scope.story.tasks = [];
  $scope.story.attachments = [];

  // Base Task
  $scope.newTask = new Task({ assigned_to: 0 });

  // Tracking file uploads
  $scope.fileUploads = [];
  $scope.currentlyUploading = 0;

  // Set up page depending on story type
  if (StoryType === "todo") {
    $scope.titlePlaceholder = "Todo List Title...";
    $scope.createBtnText = "Create list";
    $scope.showingTodoList = true;

  } else if (StoryType === "discussion") {
    $scope.titlePlaceholder = "Discussion Title...";
    $scope.createBtnText = "Create discussion";
    $scope.descriptionPlaceholder = "Discussion content...";
    $scope.showingDescriptionField = true;

  } else if (StoryType === "file") {
    $scope.titlePlaceholder = "Files title...";
    $scope.createBtnText = "Create files";
    $scope.descriptionPlaceholder = "Files description...";
    $scope.showingDescriptionField = true;
    $scope.showingAttachedFiles = true;
  }

  // Set the current user
  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  // Set the current project
  Project.get($routeParams.slug).then(function(project) {
    $scope.project = project;
  });

  // Adds task to array and resets the new task
  $scope.addTask = function(task) {
    task.id = "new-item:" + Math.random(99999999);
    $scope.story.tasks.push(angular.copy(task));
    $scope.newTask = new Task({ assigned_to: 0 });
  };

  // When a task is removed - remove it from the tasks array
  $rootScope.$on('task:deleted', function(_ev, task_id){
    $scope.story.tasks = _.reject($scope.story.tasks, function(task){
      return task.id == task_id;
    });
  });

  // Uploads a new file
  $scope.addFiles = function($files) {
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
          file.uploadProgress = 0;

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
              file_name: file.name,
              file_size: file.size,
              content_type: file.type,
              file_path: awsData.file_path,
            });

            $scope.story.attachments.push(attachment);
          }); // upload
        }); // presignedUrl
      }
    });
  };

  // Creates the story and redirects to it
  $scope.createStory = function(story) {
    story.create().then(function(story) {
      $location.path("/"+story.story_type+"s/"+story.slug);
    });
  };
});
