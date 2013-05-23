
jQuery.ajaxSetup({
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function(){
    $('#login_email').focus();

    $("a.forgot-password").click(function(e){
        e.preventDefault();
        e.stopPropagation();

        var trigger = $(this);
        var modal = trigger.attr('href');

        $.post("/renewal", "session[action]=get_form", null, "script")
            .always(function(){
                $(modal).children('div.modal-body').css('max-height', '400px');

                //VERTICAL ALIGNMENT FOR THE PASSWORD FORM


                var modal_height = $(modal).height();
                var height = 625;

                var modal_top = (height / 2) - (modal_height / 2);

                $(modal).css('top', modal_top + "px");



                $(modal).modal('show');
            });
    });

    $("form.request_password_renewal").submit(function(){
        var trigger = $(this);
        var button = trigger.find("input[type='submit']");

        trigger.siblings("p.alert").removeClass('alert-error').empty().hide();

        $(button).attr('data-original-text', $(button).val());
        $(button).val("Sending...");
        $(button).attr('type', 'button');

        $.post(this.action, trigger.serialize(), null, "script")
            .always(function(){
                var button = trigger.find("input[type='button']");

                $(button).val($(button).attr('data-original-text'));
                $(button).attr('type', 'submit');
            });

        return false;
    });

    $("form.change_password").on('submit', function(){
        var trigger = $(this);
        var button = trigger.find("input[type='submit']");

        trigger.siblings("p.alert").removeClass('alert-error').empty().hide();

        button.attr('data-original-text', button.val());
        button.val("Submitting...");
        button.attr('type', 'button');

        $.post(this.action, trigger.serialize(), null, "script")
            .always(function(){
                var button = trigger.find("input[type='button']");

                button.val(button.attr('data-original-text'));
                button.attr('type', 'submit');
            });

        return false;
    });

    $("form.user_login").submit(function(){
        var trigger = $(this);
        var button = trigger.find("input[type='submit']");

        button.attr('data-original-text', button.val())
            .val("Logging In...")
            .attr('type', 'button')
            .css('width', '100px');

        $.post(this.action, trigger.serialize(), null, "script")
            .always(function(){
                var button = trigger.find("input[type='button']");

                button.val(button.attr('data-original-text'))
                    .attr('type', 'submit')
                    .css('width', '60px');

            });

        return false;
    });

    $("form.approve_terms").submit(function(){
        $.post(this.action, trigger.serialize(), null, "script");
        return false;
    });

});

