app.controller('HomeController', ['$scope', '$http', function($scope, $http) {

    //map reference
    $scope.map = null;

    //bar by day list
    $scope.barList = {};
    $scope.barList = $('#bar-data').data('bars');

    //location
    $scope.location = $('#location-data').data('location');

    infoWindowList = [];
    markerList= [];

    $scope.autoComplete = null;



    $scope.refreshMap = function(lat, lng) {

        //clear markers
        for (var i = 0; i < markerList.length; i++) {
            markerList[i].setMap(null);
        }
        markerList = [];

        //clear info list
        infoWindowList = [];

        //create marker for each bar
        $.each($scope.barList, function(day, bars){
            $.each(bars, function(index, bar){

                //create marker
                var marker = new google.maps.Marker({
                    position: {lat: parseFloat(bar.lat), lng: parseFloat(bar.long)},
                    map: $scope.map,
                    animation: google.maps.Animation.DROP,
                    title: bar.name
                });

                markerList.push(marker);
                marker.trivia_day = bar.trivia_day;


                //create info window
                var infowindow = new google.maps.InfoWindow({
                    content: '<div class="marker-window"> <p>'+bar.name+'</p> <p>'+bar.address+'</p> <p>'+bar.city + ", " + bar.state + " " + bar.zip+'</p></div>'
                });

                infoWindowList.push(infowindow);


                //bind click listener to open window
                marker.addListener('click', function() {

                    //close other windows
                    $.each(infoWindowList, function(){
                        this.close();
                    });

                    //open this one
                    infowindow.open(map, marker);
                });

            });
        });

        //pan map
        var center = new google.maps.LatLng(lat, lng);
        $scope.map.panTo(center);
    }


    var placeChanged = function() {

        var place = $scope.autocomplete.getPlace();
        var lat = place.geometry.location.lat();
        var long = place.geometry.location.lng();
        var radius = 30;

        //make http call to bar endpoint
        $http({
            method: 'GET',
            url: '/bars',
            params: {lat: lat, long: long, radius: radius}
        }).then(function successCallback(response) {

            $scope.barList = response.data;

            $scope.refreshMap(lat, long);

        }, function errorCallback(response) {

            console.log('Error getting bar list from server');

        });

    }

    //init function that is called by the map api script after it is loaded
    window.initMap = function() {


        //if there is no map div on this page, return
        if(!$('#map').length)
        {
            return;
        }

        var bostonLatLng = {lat: 42.360082, lng: -71.0589};

        // Create a map object and specify the DOM element for display.
        $scope.map = new google.maps.Map(document.getElementById('map'), {
            center: bostonLatLng,
            //scrollwheel: false,
            zoom: 13,
            mapTypeControl: false,
            streetViewControl: false,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });

        //refresh map
        $scope.refreshMap(bostonLatLng.lat, bostonLatLng.lng);

        //init autocomplete
        $scope.autocomplete = new google.maps.places.Autocomplete((document.getElementById('autocomplete')),{types: ['geocode']});
        $scope.autocomplete.addListener('place_changed', placeChanged);

    }


}]);