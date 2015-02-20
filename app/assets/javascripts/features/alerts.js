$(function() {
    $(document).on("click", ".ui-notification .close-cross", function() {
        var $alert = $(this).closest(".ui-notification");

        $alert.addClass("dismiss");

        $alert.one('webkitTransitionEnd mozTransitionEnd MSTransitionEnd transitionend', function() {
            $alert.remove();
        });
    });


    App.onPageLoad(function() {
        if ($(".auto-dismiss").length < 1) return;

        setTimeout(function() {
            $(".auto-dismiss").addClass("dismiss");

            $(".auto-dismiss").one('webkitTransitionEnd mozTransitionEnd MSTransitionEnd transitionend', function() {
                $(".auto-dismiss").remove();
            });
        }, 3000);
    });
});
