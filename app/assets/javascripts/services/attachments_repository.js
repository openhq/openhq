angular.module("OpenHq").factory("AttachmentsRepository", function($http) {
  return {
    presignedUrl: function(file) {
      return $http({
        method: "GET",
        url: "/api/v1/attachments/presigned_upload_url",
        params: {
          file_name: file.name,
          file_type: file.type
        }
      }).then(function(resp) {
        return resp.data;
      });
    }
  };
});
