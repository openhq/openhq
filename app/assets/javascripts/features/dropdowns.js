$(function() {
    $(document).on("click", function() {
        $(".ui-dropdown-menu.open").removeClass("open");
    });

    $(document).on("click", ".ui-dropdown-menu", function(ev) {
        ev.stopPropagation();
    });

    $(document).on("click", ".ui-dropdown-menu .icon", function() {
        var $menu = $(this).closest(".ui-dropdown-menu"),
            is_open = $menu.hasClass("open");

        $('.ui-dropdown-menu.open').removeClass('open');
        if (!is_open) $menu.addClass('open');
    });
});
