app.controller('HomeController', ['$scope', '$http', function($scope, $http) {

    //bar by day list
    $scope.barList = {};

    //location
    $scope.location = {}; //{name: foo, lat: bar, lng: baz}

    //map reference
    window.map = null;

    //map markers
    window.infoWindowList = [];
    window.markerList= [];

    //autocomplete box reference
    window.autoComplete = null;



    //init function that is called by the map api script after it is loaded
    window.initMap = function() {

        //if there is no map div on this page, return
        if(!$('#map').length)
        {
            return;
        }

        //get default bar and location data from page
        var default_data = $('#default-data').data('preloaded');
        $scope.barList = default_data.bars;
        $scope.location = default_data.location;


        // Create a map object and specify the DOM element for display.
        window.map = new google.maps.Map(document.getElementById('map'), {
            center: {lat: $scope.location.lat, lng: $scope.location.lng},
            //scrollwheel: false,
            zoom: 13,
            mapTypeControl: false,
            streetViewControl: false,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });

        //init autocomplete search box
        window.autocomplete = new google.maps.places.Autocomplete((document.getElementById('autocomplete')),{types: ['geocode']});
        window.autocomplete.addListener('place_changed', placeChanged);

        //refresh map
        $scope.refreshMap();

    }


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
                    title: bar.name
                });

                window.markerList.push(marker);
                marker.trivia_day = bar.trivia_day;


                //create info window
                var infowindow = new google.maps.InfoWindow({
                    content: '<div class="marker-window"> <p>'+bar.name+'</p> <p>'+bar.address+'</p> <p>'+bar.city + ", " + bar.state + " " + bar.zip+'</p></div>'
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
    }


    var placeChanged = function() {

        //set new location data
        var place = window.autocomplete.getPlace();
        $scope.location.name = place.formatted_address;
        $scope.location.lat = place.geometry.location.lat();
        $scope.location.lng = place.geometry.location.lng();
        var radius = 30;

        //make http call to bar endpoint
        $http({
            method: 'GET',
            url: '/bars',
            params: {lat: $scope.location.lat, long: $scope.location.lng, radius: radius}
        }).then(function successCallback(response) {

            //ser new bar list
            $scope.barList = response.data;

            $scope.refreshMap();

        }, function errorCallback(response) {

            console.log('Error getting bar list from server');

        });

    }

}]);