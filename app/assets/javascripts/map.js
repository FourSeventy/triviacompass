function initMap() {
    var myLatLng = {lat: 42.360082, lng: -71.0589};

    // Create a map object and specify the DOM element for display.
    var map = new google.maps.Map(document.getElementById('map'), {
        center: myLatLng,
        scrollwheel: false,
        zoom: 13,
        mapTypeControl: false,
        streetViewControl: false,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    //make geocoder
    var geocoder = new google.maps.Geocoder();

    //get list of bars
    barList = [];
    barList = $('#bar-data').data('bars');


    //create marker for each bar
    //$.each(barList, function(index, bar){
    //
    //    var address = bar.address + ', ' + bar.city + ', ' + bar.zip;
    //    geocodeAddress(address, geocoder, map);
    //});


};

function geocodeAddress(address, geocoder, resultsMap) {

    geocoder.geocode({'address': address}, function (results, status) {
        if (status === google.maps.GeocoderStatus.OK)
        {
            resultsMap.setCenter(results[0].geometry.location);
            var marker = new google.maps.Marker({
                map: resultsMap,
                position: results[0].geometry.location
            });
        }
        else
        {
            alert('Geocode was not successful for the following reason: ' + status);
        }
    });
}
