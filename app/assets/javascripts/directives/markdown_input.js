angular.module("OpenHq").directive("markdownInput", function() {
  return {
    restrict: "E",
    scope: {
      content: '=',
      filler: '=',
    },
    template: JST['templates/directives/markdown_input'],
    link: function(scope, element, attrs, controller, transcludeFn) {
      $(element).find('.atwho').atwho({
        at:"@",
        displayTpl: "<li title=\"${display_name}\"><img src='${avatar_url}?s=40' width='20'> <span class='value'>${username}</span></li>",
        insertTpl: "@${username}",
        searchKey: "username",
        data: "/api/v1/mentions/users"
      }).atwho({
        at: ":",
        data: "/api/v1/mentions/emojis",
        displayTpl: "<li><img src='https://a248.e.akamai.net/assets.github.com/images/icons/emoji/${name}.png' height='20' width='20'/> <span class='value'>${name}</span></li>",
        insertTpl: ":${name}:"
      });
    }
  };
});
