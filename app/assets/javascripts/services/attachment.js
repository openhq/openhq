angular.module("OpenHq").factory("Attachment", function(railsResourceFactory) {

  return railsResourceFactory({
    url: "/api/v1/attachments",
    name: "attachment"
  });

});


