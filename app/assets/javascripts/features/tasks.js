$(function(){

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
            if (resp.result) {
                li.toggleClass('complete');

                count = li.closest('ul').find('li:not(.complete)').length
                li.closest('.tasks').find('h4').html(
                    count + " Incomplete Task" + (count == 1 ? "" : "s")
                );
            }
        });
    });

    // rearranging a task list
    $(".tasks ul.sortable").sortable({
        update: function(event, ui) {
            var $this = $(this);
            var order = $this.sortable("toArray");

            $.ajax({
                type: "put",
                url: $this.data('update-url'),
                data: {
                  order: order
                }
            })
            .done(function(resp){
                console.log('order updated');
            });
        }
    });

    // clicking the edit button
    $('.tasks ul li ul.actions a.edit').on('click', function(ev){
        ev.preventDefault();
        toggleEditTaskForm(ev);
    });

    // clicking the cancel edit button
    $('.tasks .edit-form a.cancel').on('click', function(ev){
        ev.preventDefault();
        toggleEditTaskForm(ev);
    });

    // submitting the edit form
    $('.tasks .edit-form form').on('submit', function(ev){
        ev.preventDefault();

        var $this = $(ev.currentTarget);

        $.ajax({
                type: "put",
                url: $this.attr('action'),
                data: $this.serialize()
            })
            .done(function(resp){
                if (resp.result) {
                    console.log(resp.task);
                    $this.closest('li.task').find('span.label').html(resp.task.label);
                    $this.closest('li.task').find('span.assignment').html(resp.task.assignment_name);
                    toggleEditTaskForm(ev);
                }
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

});