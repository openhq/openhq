$(function() {
    $(document).on("click", ".ui-dropdown-menu .icon", function() {
        var $menu = $(this).closest(".ui-dropdown-menu");

        $menu.toggleClass("open");
    });
});
