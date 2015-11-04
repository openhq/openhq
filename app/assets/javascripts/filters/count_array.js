angular.module("OpenHq").filter("countArray", function() {

  /**
   * Counts an array
   * @param  {Array} items
   * @return {Integer} count
   */
  return function(items) {
    return _.isArray(items) ? items.length : 0;
  };

});
