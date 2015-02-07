App.onPageLoad(function() {

    $("input.datepicker").pickadate({
        firstDay: 1,
        formatSubmit: "yyyy-mm-dd",
        hiddenName: true
    });

});
