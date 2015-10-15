$(document).ready(function(){
    $.ajax({
        url: "/api/user",
        method: "GET",
        dataType: "json"
    })
    .done(function(user){
        var bus = window.MessageBus;

        bus.subscribe("/user/"+user.id+"/notifications", function(data) {
            $(document).trigger('notification:new', data);
        });
    });
});