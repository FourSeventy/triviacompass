$( document ).ready(function() {


    function sendRequest(url){

        $.ajax({ url: url,
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},

        }).done(function(data){

            console.log(data);
            $("#results").html(JSON.stringify(data));
        }).fail(function(data){
            console.log("fail");
        });
    }


    $('#scrape-geeks').click(function(){
        sendRequest('/admin/scrapeGeeks');
    });

    $('#scrape-stump').click(function(){

        sendRequest('/admin/scrapeStump');
    });

    $('#scrape-brain').click(function(){
        sendRequest('/admin/scrapeBrain');
    });

    $('#scrape-sporcle').click(function(){
        sendRequest('/admin/scrapeSporcle');
    });

    $('#scrape-trivianation').click(function(){
        sendRequest('/admin/scrapetrivianation');
    });

});