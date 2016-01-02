app.controller('HomeController', ['$scope', '$http', '$cookies', function($scope, $http, $cookies) {

    //bar by day list
    $scope.barList = {};

    //location
    $scope.location = {}; //{name: foo, lat: bar, lng: baz}

    //options
    $scope.options = {};

    //map reference
    window.map = null;

    //map markers
    window.infoWindowList = [];
    window.markerList= [];

    //autocomplete box reference
    window.autoComplete = null;

    $scope.findClick = function() {

        $("#autocomplete").focus();
        var e = $.Event("keypress", { which: 13, keyCode: 13 });
        $("#autocomplete").trigger(e);
    };

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


    var placeChanged = function() {

        //set new location data
        var place =  window.autocomplete.getPlaces()[0];

        if (!place.geometry)
        {
            return;
        }

        $scope.location.name = place.formatted_address;
        $scope.location.lat = place.geometry.location.lat();
        $scope.location.lng = place.geometry.location.lng();
        var radius = $scope.options.radius;

        //make http call to bar endpoint
        $http({
            method: 'GET',
            url: '/bars',
            params: {lat: $scope.location.lat, long: $scope.location.lng, radius: radius}
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
            styles:[{"elementType":"geometry","stylers":[{"hue":"#ff4400"},{"saturation":-68},{"lightness":-4},{"gamma":0.72}]},{"featureType":"road","elementType":"labels.icon"},{"featureType":"landscape.man_made","elementType":"geometry","stylers":[{"hue":"#0077ff"},{"gamma":3.1}]},{"featureType":"water","stylers":[{"hue":"#00ccff"},{"gamma":0.44},{"saturation":-33}]},{"featureType":"poi.park","stylers":[{"hue":"#44ff00"},{"saturation":-23}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"hue":"#007fff"},{"gamma":0.77},{"saturation":65},{"lightness":99}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"gamma":0.11},{"weight":5.6},{"saturation":99},{"hue":"#0091ff"},{"lightness":-86}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"lightness":-48},{"hue":"#ff5e00"},{"gamma":1.2},{"saturation":-23}]},{"featureType":"transit","elementType":"labels.text.stroke","stylers":[{"saturation":-64},{"hue":"#ff9100"},{"lightness":16},{"gamma":0.47},{"weight":2.7}]}]
        });

        //init autocomplete search box
        window.autocomplete = new google.maps.places.SearchBox((document.getElementById('autocomplete')));
        google.maps.event.addListener(window.autocomplete, 'places_changed', placeChanged);


        //refresh map
        $scope.refreshMap();

    })();


}]);