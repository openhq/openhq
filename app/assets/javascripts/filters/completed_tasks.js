angular.module("OpenHq").filter("completedTasks", function() {

  /**
   * Returns completed tasks from a list of tasks
   * @param  {Array} tasks
   * @return {Array} completed tasks
   */
  return function(tasks) {
    return _.reject(tasks, function(task) {
      if ( ! task.completed) return true;
    });
  };

});
