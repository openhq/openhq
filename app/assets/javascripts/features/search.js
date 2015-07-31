$(function(){
    App.onPageLoad(function() {
        $(document).ready(function(){

            var hash = window.location.hash,
                $target = false;

            if (hash) {
                hash = hash.split(':');
                if (hash[0] == "#task") {
                    $target = $('.tasks li[data-id='+hash[1]+']');
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
                    $target.addClass('warmdown');

                    $('html,body').animate({
                      scrollTop: ($target.offset().top - 100)
                    }, 300);

                    setTimeout(function() {
                        $target.removeClass('warmdown');
                    }, 3000);
                }
            }

        });
    });
});