angular.module("OpenHq").filter("shortDate", function() {

  /**
   * Formats the date in short form with descriptive words for
   * today / tomorrow / yesterday
   * @param  {Date} datetime
   * @return {String} formatted date
   */
  return function(datetime) {
    var time = moment.parseZone(datetime);
    console.log("shortDate", time);

    return time.calendar(null, {
        sameDay: '[Today]',
        nextDay: '[Tomorrow]',
        nextWeek: 'Do MMM',
        lastDay: '[Yesterday]',
        lastWeek: 'Do MMM'
    });
  };

});
