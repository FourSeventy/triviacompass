(function(mapPage){


    barList = [];
    barList = $('#bar-data').data('bars');
    infoWindowList = [];
    markerList= [];

    //init function that is called by the map api script after it is loaded
    mapPage.initMap = function() {

        var bostonLatLng = {lat: 42.360082, lng: -71.0589};

        // Create a map object and specify the DOM element for display.
        var map = new google.maps.Map(document.getElementById('map'), {
            center: bostonLatLng,
            //scrollwheel: false,
            zoom: 13,
            mapTypeControl: false,
            streetViewControl: false,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });

        //create marker for each bar
        $.each(barList, function(index, bar){

            //create marker
            var marker = new google.maps.Marker({
                position: {lat: parseFloat(bar.lat), lng: parseFloat(bar.long)},
                map: map,
                animation: google.maps.Animation.DROP,
                title: bar.name
            });

            markerList.push(marker);


            //create info window
            var infowindow = new google.maps.InfoWindow({
                content: '<div class="marker-window"> <p>'+bar.name+'</p> <p>'+bar.address+'</p> <p>'+bar.city + ", " + bar.state + " " + bar.zip+'</p></div>'
            });

            infoWindowList.push(infowindow);

            
            //bind click listener to open window
            marker.addListener('click', function() {

                //close other windows
                $.each(infoWindowList, function(index, window){
                    window.close();
                });

                //open this one
                infowindow.open(map, marker);
            });

        });
    }


})(window.mapPage = window.mapPage || {});
