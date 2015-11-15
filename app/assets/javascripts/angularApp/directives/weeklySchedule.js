app.directive('weeklySchedule', function() {
    return {
        restrict: 'E',
        scope: {
            bars: '='
        },
        templateUrl: 'assets/angularApp/directives/weeklySchedule.html'
    };
});