$(function(){
    App.onPageLoad(function() {
        // After clicking on a result
        // add a warmdown style to the result
        addWarmdown();
        renderSearchResults();
    });

    function addWarmdown() {
        var hash = window.location.hash,
            $target = false;

        if (!hash) return;

        hash = hash.split(':');

        if (hash[0] == "#task") {
            $target = $('.tasks li[data-id='+hash[1]+']');
            // if the task has been completed, click the show completed tasks
            // button to make sure that it can be seen on screen
            if ($target.hasClass('complete')) {
                $('.show-completed-tasks').click();
            }
        }
        else if (hash[0] == "#comment") {
            $target = $('article.comment-row[data-id='+hash[1]+']');
        }
        else if (hash[0] == "#attachment") {
            $target = $('.file-list li[data-id='+hash[1]+']');
        }

        if ($target && $target.length) {
            $(document).on('page:loaded', function(){
                $target.addClass('warmdown');

                $('html,body').animate({
                  scrollTop: ($target.offset().top - 100)
                }, 300);

                setTimeout(function() {
                    $target.removeClass('warmdown');
                }, 3000);
            });
        }
    }

    function renderSearchResults() {
        $results_list = $('ul.ui-search-list');
        if (!$results_list.length) return;

        // loop through each result and either
        //  - show the li if the user is part of the project
        //  - remove the li if not not part of the project
        _.each($results_list.find('li'), function(li){
            var $li = $(li);
            // if the project id is not within the users project ids
            if (_.indexOf(user_project_ids, $li.data('project-id')) < 0) {
                $li.remove();
            } else {
                $li.show();
            }
        });

        // Update the title of the page with the number of results
        var num_results = $results_list.find('li').length
        $('.page-header.search h1 span').text(num_results + (num_results > 1 ? " results" : " result"));
        $('.page-header.search').show();
    }
});