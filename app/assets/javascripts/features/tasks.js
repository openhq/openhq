$(function(){

    App.onPageLoad(function() {
        // If we’re on a story update task completion status
        if ($(".ui-story").find(".tasks").length > 0) {
            updateTaskCompletionBar();
        }

        // setting a task as complete / incomplete
        $('.tasks li input[type=checkbox]').on('change', function(e){
            var $this = $(this);
            var li = $this.closest('li');
            var url = $this.closest('form').attr('action');
            var completed = $this.is(':checked');

            $.ajax({
                type: "put",
                url: url,
                data: {
                  completed: completed
                }
            })
            .done(function(resp){
                li.toggleClass('complete').show();

                updateTaskCompletionBar();
            })
            .fail(function(resp){
                console.log('error', resp.error);
            });
        });

        // rearranging a task list
        $(".tasks ul.sortable").sortable({
            items: ".task",
            update: function(event, ui) {
                var $this = $(this);
                var order = $this.sortable("toArray");

                $.ajax({
                    type: "put",
                    url: $this.data('update-url'),
                    data: {
                      order: _.compact(order)
                    }
                })
                .done(function(resp){
                    console.log('order updated');
                });
            }
        });

    });

    // clicking the edit button
    $(document).on('click', '.tasks ul li ul.actions a.edit', function(ev){
        ev.preventDefault();
        toggleEditTaskForm(ev);
    });

    // clicking the cancel edit button
    $(document).on('click', '.tasks .edit-form a.cancel', function(ev){
        ev.preventDefault();
        toggleEditTaskForm(ev);
    });

    // submitting the edit form
    $(document).on('submit', '.tasks .edit-form form', function(ev){
        ev.preventDefault();

        var $this = $(ev.currentTarget);

        $.ajax({
                type: "put",
                url: $this.attr('action'),
                data: $this.serialize()
            })
            .done(function(resp){
                $this.closest('li.task').find('span.label').html(resp.task.label);
                $this.closest('li.task').find('span.assignment').html(resp.task.assignment_name);
                toggleEditTaskForm(ev);
            })
            .fail(function(resp){
                console.log('error', resp.error);
            });
    });

    function toggleEditTaskForm(ev) {
        var $this = $(ev.currentTarget),
            $li = $this.closest('li.task'),
            $default_form = $li.find('.default-form form'),
            $edit_form = $li.find('.edit-form form');

        $default_form.toggle();
        $edit_form.toggle();
    }

    function updateTaskCompletionBar() {
        var $task_list = $(".ui-story").find(".tasks"),
            overall = $task_list.find('li.task').length,
            complete = $task_list.find('li.task:not(.complete)').length,
            pct_complete = (100 - Math.round((complete/overall) * 100)) + "%";

        $task_list.find('h4').html(
            complete + " Incomplete Task" + (complete == 1 ? "" : "s")
        );

        if (overall < 1) {
            $('.story-menu .overall-task-progress').hide();
        }
        else {
            $('.story-menu .progress-bar span.completion').html(pct_complete).css({width: pct_complete});
            $('.story-menu .overall-task-progress').show();
        }
    }

    // show completed tasks
    $(document).on('click', '.tasks a.show-completed-tasks', function(ev){
        ev.preventDefault();
        $(ev.currentTarget).closest("li").hide();

        $('.tasks li.complete').show();
    });

});
