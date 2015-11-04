angular.module("OpenHq").filter("incompleteTasks", function() {

  /**
   * Returns incomplete tasks from a list of tasks
   * @param  {Array} tasks
   * @return {Array} incomplete tasks
   */
  return function(tasks) {
    return _.reject(tasks, function(task) {
      if (task.completed) return true;
    });
  };

});
