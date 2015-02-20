$(function() {
    $(document).on("click", ".ui-notification .close-cross", function() {
        var $alert = $(this).closest(".ui-notification");

        $alert.addClass("dismiss");

        $alert.one('webkitTransitionEnd mozTransitionEnd MSTransitionEnd transitionend', function() {
            $alert.remove();
        });
    });
});
