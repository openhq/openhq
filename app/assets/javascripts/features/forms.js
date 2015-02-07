App.onPageLoad(function() {

    // Setup special select fields
    $("select.chosen-select").chosen();
    $("select[multiple]").chosen({no_results_text: "Oops, nothing found!"});

});
