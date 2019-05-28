$(document).ready(function(){
    $('.item_attr').click( function() {
        $(this).closest(".container").find('.selected').removeClass('selected');
        $(this).addClass('selected');
        $(this).closest(".container").removeClass('error');
    });

    $('#inputCarat').change(function(){
        validateCaratValue();
    });

    $('button').click( function() {
        let getAjax = true;

        validateCaratValue();

        $(".attr_container").each(function(){
            if($(this).find('.selected').length == 0) {
                getAjax = false;
                $(this).addClass('error');
            }
        });

        if(getAjax) {
            console.log();
            let carat = $('#inputCarat').val().replace('.', '-' );
            let shape = $(".shape_attr.selected").html();
            let color = $(".color_attr.selected").html();
            let clarity = $(".clarity_attr.selected").html();;

            $.get( "/recent_deals/" + carat+ "/" + shape + "/" + color + "/" + clarity, function(data) {
                $("#inputPrice").val(data.price);
            }).fail(function() {
                console.log( "error" );
            });
        }
    });
});

function validateCaratValue() {
    let allowed = true;
    let carat_val = $('#inputCarat').val();
    let carat_container = $('#inputCarat').closest(".container");

    if(carat_val == "" || ! $.isNumeric(carat_val) || carat_val < 0.01 ||  carat_val > 15 ) {
        allowed = false;
        carat_container.addClass('error');
    } else {
        carat_container.removeClass('error');
    }

    return allowed;
}

