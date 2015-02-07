$(function() {
    $(document).on("click", ".ui-dropdown-menu .title", function() {
        var $menu = $(this).closest(".ui-dropdown-menu");

        $menu.toggleClass("open");
    });
});
