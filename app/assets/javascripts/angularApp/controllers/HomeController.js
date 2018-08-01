app.controller('HomeController', ['$scope', '$http', '$cookies', function($scope, $http, $cookies) {

    //bar by day list
    $scope.barList = {};

    //location
    $scope.location = {}; //{name: foo, lat: bar, lng: baz}

    //options
    $scope.options = {};

    //day of week to filter on
    $scope.dayFilter = 'all';

    //map reference
    window.map = null;

    //map markers
    window.infoWindowList = [];
    window.markerList= [];

    //autocomplete box reference
    window.autoComplete = null;




    $scope.refreshMap = function() {

        //clear markers
        for (var i = 0; i < window.markerList.length; i++)
        {
            window.markerList[i].setMap(null);
        }
        window.markerList = [];

        //clear info list
        window.infoWindowList = [];

        //create marker for each bar
        $.each($scope.barList, function(day, bars){

            if($scope.dayFilter != 'all' && $scope.dayFilter != day){
                return true; //continue to next bar
            }

            $.each(bars, function(index, bar){

                //create marker
                var marker = new google.maps.Marker({
                    position: {lat: parseFloat(bar.lat), lng: parseFloat(bar.long)},
                    map: window.map,
                    animation: google.maps.Animation.DROP,
                    title: bar.name,
                    icon: window.image_path('pin.png')
                });

                window.markerList.push(marker);
                marker.trivia_day = bar.trivia_day;


                //create info window
                var infowindow = new google.maps.InfoWindow({
                    content: '<div class="marker-window"> <p class="marker-name">'+bar.name+'</p> <p class="marker-address">'+bar.address+"</br>"+bar.city + ", " + bar.state + " " + bar.zip+"</p><p class='marker-address'>"+bar.trivia_day +", "+bar.trivia_time+"</p></div>"
                });

                window.infoWindowList.push(infowindow);


                //bind click listener to open window
                marker.addListener('click', function() {

                    //close other windows
                    $.each(window.infoWindowList, function(){
                        this.close();
                    });

                    //open this one
                    infowindow.open(map, marker);
                });

            });
        });

        //pan map
        var center = new google.maps.LatLng($scope.location.lat, $scope.location.lng);
        window.map.panTo(center);
    };


    var getBarListAndRefresh = function(name, lat, lng) {

        //set day filter back to all
        $scope.dayFilter = 'all'
        
        //set our scope location data
        $scope.location.name = name;
        $scope.location.lat = lat;
        $scope.location.lng = lng;

        //make http call to bar endpoint
        $http({
            method: 'GET',
            url: '/bars',
            params: {lat: $scope.location.lat, long: $scope.location.lng, radius: $scope.options.radius}
        }).then(function successCallback(response) {

            //ser new bar list
            $scope.barList = response.data;

            //refresh the map with new bars
            $scope.refreshMap();

            //drop a cookie to remember location
            $cookies.put('location',JSON.stringify({name: $scope.location.name, lat: $scope.location.lat, lng: $scope.location.lng }));


        }, function errorCallback(response) {

            console.log('Error getting bar list from server');

        });

        $('#search-header').addClass('searched');
        $('#search-header button').html('Search Again');
        $('#autocomplete').attr('placeholder','Looking for someplace else?');

    }


    //listener for place autocomplete box change
    var placeChanged = function() {

        //set new location data
        var place =  window.autocomplete.getPlaces()[0];

        if (!place.geometry) {
            return;
        }

        var name = place.formatted_address;
        var lat = place.geometry.location.lat();
        var lng = place.geometry.location.lng();

        try {
            ga('send', 'event', "search", "autocomplete", name);
        }
        catch(e) {
            console.log("GA tracking error");
        }

        getBarListAndRefresh(name,lat,lng);

    };

    //listener for find button
    $scope.findButtonClick = function() {

        // get autocomplete text
        var location = $('#autocomplete').val();

        //geocode location
        var geocoder = new google.maps.Geocoder();
        geocoder.geocode( { 'address': location}, function(results, status) {

            //if status is bad or results.size is 0 dont do anything
            if (status != google.maps.GeocoderStatus.OK || results.length == 0) {
                return;
            }

            //pull out data we need
            var address = results[0].formatted_address;
            var lat = results[0].geometry.location.lat();
            var lng = results[0].geometry.location.lng();

            try {
                ga('send', 'event', "search", "findButton", address);
            }
            catch(e) {
                console.log("GA tracking error");
            }

            getBarListAndRefresh(address,lat,lng);

        });
    };



    (function init() {

        //if there is no map div on this page, return
        if(!$('#map').length)
        {
            return;
        }

        //get default bar and location data from page
        var default_data = $('#default-data').data('preloaded');
        $scope.barList = default_data.bars;
        $scope.location = default_data.location;
        $scope.options = default_data.options;


        // Create a map object and specify the DOM element for display.
        window.map = new google.maps.Map(document.getElementById('map'), {
            center: {lat: $scope.location.lat, lng: $scope.location.lng},
            scrollwheel: false,
            zoom: 13,
            mapTypeControl: false,
            streetViewControl: false,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            styles: [{"featureType":"administrative","elementType":"all","stylers":[{"visibility":"on"},{"lightness":33}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2e5d4"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#c5dac6"}]},{"featureType":"poi.park","elementType":"labels","stylers":[{"visibility":"on"},{"lightness":20}]},{"featureType":"road","elementType":"all","stylers":[{"lightness":20}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#c5c6c6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#e4d7c6"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#fbfaf7"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"on"},{"color":"#acbcc9"}]}]
        });

        //init autocomplete search box
        window.autocomplete = new google.maps.places.SearchBox((document.getElementById('autocomplete')));
        google.maps.event.addListener(window.autocomplete, 'places_changed', placeChanged);


        //refresh map
        $scope.refreshMap();

    })();


}]);
