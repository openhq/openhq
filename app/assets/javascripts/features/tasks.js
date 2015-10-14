$(function(){
    var tasks_container_template = JST['templates/tasks/container'],
        task_template = JST['templates/tasks/task'];

    App.onPageLoad(function() {
        // Add tasks if there are any
        if ($(".ui-story").find(".tasks").length > 0) {
            addAllTasks();
        }
    });

    function addAllTasks() {
        var $container = $('.tasks');

        $.ajax({
            url: $container.attr('data-url'),
            method: "GET",
            dataType: "json"
        })
        .done(function(resp){
            var tasks_html = "",
                incomplete_count = 0;

            // build up html of all the tasks
            _.each(resp.tasks, function(task){
                tasks_html += task_template(task);
                if (!task.completed) incomplete_count++;
            });

            // the overall html including incomplete count etc.
            $container.prepend(tasks_container_template({
                count: resp.tasks.length,
                incomplete_count: incomplete_count,
                order_url: $container.attr('data-url') + '/update-order',
                delete_url: $container.attr('data-url') + '/delete-completed',
                tasks_html: tasks_html
            }));

            setupDatepickers();

            $container.find('.loader').remove();
            if (!resp.tasks.length) {
                $('.tasks .no-tasks').show();
                $('.tasks .tasks-list-container').hide();
            } else {
                $('.tasks .no-tasks').hide();
                $('.tasks .tasks-list-container').show();
            }

            // make the tasks sortable
            setTasksAsSortable();

            // update the task completion percentage
            updateTaskCompletionBar();
        });
    }

    function updateTaskCompletionBar() {
        var $task_list = $(".ui-story").find(".tasks"),
            overall = $task_list.find('li.task').length,
            complete = $task_list.find('li.task:not(.complete)').length,
            pct_complete = (100 - Math.round((complete/overall) * 100)) + "%";

        $task_list.find('h4.incomplete-tasks-title').html(
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

    function setTasksAsSortable(){
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
    }

    // setting a task as complete / incomplete
    $(document).on('change', '.tasks li input[type=checkbox]', function(e){
        var $this = $(this),
            li = $this.closest('li'),
            url = $this.closest('form').attr('action'),
            completed = $this.is(':checked');

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

    // clicking the edit button
    $(document).on('click', '.tasks ul li ul.actions a.edit', function(ev){
        ev.preventDefault();
        var $this = $(ev.currentTarget),
            $li = $this.closest('li.task');
        toggleEditTaskForm($li);
    });

    $(document).on('dblclick', '.tasks li.task:not(.complete) .default-form', function(ev){
        var $label = $(ev.currentTarget)
            $li = $label.closest('li.task');
        toggleEditTaskForm($li);
    });

    // clicking the cancel edit button
    $(document).on('click', '.tasks .edit-form a.cancel', function(ev){
        ev.preventDefault();
        var $this = $(ev.currentTarget),
            $li = $this.closest('li.task');
        toggleEditTaskForm($li);
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
                var $li = $this.closest('li.task');
                $li.after(task_template(resp.task));
                setupDatepickers();
                $li.remove();
            })
            .fail(function(resp){
                console.log('error', resp.error);
            });
    });

    function toggleEditTaskForm($li) {
        if ($li.hasClass('edit-open')) {
            $li.removeClass('edit-open');
        } else {
            $li.parent().find('li').removeClass('edit-open');
            $li.addClass('edit-open');
        }
    }

    // show completed tasks
    $(document).on('click', '.tasks a.show-completed-tasks', function(ev){
        ev.preventDefault();
        $(ev.currentTarget).closest("li").hide();
        $('.tasks li.complete').show();

        // show the delete all completed link
        $('a.delete-all-completed-tasks').closest('li').show();
    });

    // submitting a new task
    $(document).on('submit', '#new_task', function(ev){
        ev.preventDefault();
        $form = $(ev.currentTarget);

        if ($form.hasClass('submitting')) return;
        $form.addClass('submitting');

        $.ajax({
            url: $form.attr('action'),
            method: "POST",
            data: $form.serialize(),
            dataType: "json"
        })

        .done(function(resp){
            // reset the form to the defaults
            $form.find('.task_label input, .task_due_at input').val('');
            $form.find('select').val(0);

            $('.tasks ul li.action').before(task_template(resp.task));
            setupDatepickers();
            updateTaskCompletionBar();

            // make sure the task list is visible
            $('.tasks .no-tasks').hide();
            $('.tasks .tasks-list-container').show();
        })

        .fail(function(resp){
            console.error('fail', resp.responseJSON);
        })

        .always(function(){
            $form.removeClass('submitting');
        });
    });

    function setupDatepickers() {
        $("input.task_due_at").datepicker({
            dateFormat: "d M, yy"
        });
    }

});