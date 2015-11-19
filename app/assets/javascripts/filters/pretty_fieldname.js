angular.module("OpenHq").filter("prettyFieldname", function() {
  return function(str) {
    return str.replace('_', ' ')
              .toLowerCase()
              .replace( /\b./g, function(a){
                return a.toUpperCase();
              });
  };
});
