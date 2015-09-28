$(function() {

    $(document).on("dialogs:close", function() {
        closeAllMenuDropdowns();
    });
    $(document).on("click", function() {
        closeAllMenuDropdowns();
    });

    $(document).on("click", ".main-menu-item", function(ev) {
        ev.stopPropagation();
    });

    $(document).on("click", ".ui-dropdown-menu .icon", function() {
        var $menu = $(this).closest(".ui-dropdown-menu"),
            is_open = $menu.hasClass("open");

        closeAllMenuDropdowns();
        if (!is_open) $menu.addClass('open');
    });

    function closeAllMenuDropdowns(){
        $(".ui-dropdown-menu.open").removeClass("open");
    }
});
