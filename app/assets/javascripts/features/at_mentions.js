App.onPageLoad(function() {
  var users = _.reject(App.users, function(user) {
    if (!user.username) return true;
  });

  console.log("Valid users", users);

  $('.atwho').atwho({
    at:"@",
    displayTpl: "<li title=\"${name}\"><img src='${gravatar_url}?s=40' width='20'> <span class='value'>${username}</span></li>",
    insertTpl: "@${username}",
    searchKey: "username",
    data: users
  }).atwho({
    at: ":",
    data: App.emojis,
    displayTpl: "<li><img src='http://a248.e.akamai.net/assets.github.com/images/icons/emoji/${name}.png' height='20' width='20'/> <span class='value'>${name}</span></li>",
    insertTpl: ":${name}:"
  });
});
