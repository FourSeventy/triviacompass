app.directive('searchHeader', function() {
    return {
        restrict: 'E',
        scope: {
            location: '='
        },
        templateUrl: 'assets/angularApp/directives/searchHeader.html'
    };
});