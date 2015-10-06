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
                tasks_html: tasks_html
            }));

            $container.find('.loading').remove();
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
                $this.closest('li.task').find('p.label').html(resp.task.label);
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

    // show completed tasks
    $(document).on('click', '.tasks a.show-completed-tasks', function(ev){
        ev.preventDefault();
        $(ev.currentTarget).closest("li").hide();

        $('.tasks li.complete').show();
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
            $form.find('.task_label input').val('');
            $('.tasks ul li.action').before(task_template(resp.task));

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

});