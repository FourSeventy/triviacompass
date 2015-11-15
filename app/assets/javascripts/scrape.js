$( document ).ready(function() {

    $('#scrape').click(function(){

        $.ajax({ url: '/admin/scrape',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},

        }).done(function(data){

            console.log(data);
            $("#results").html(JSON.stringify(data));
        }).fail(function(data){
            console.log("fail");
        });


    })
});