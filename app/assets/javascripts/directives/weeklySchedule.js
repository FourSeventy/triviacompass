app.directive('weeklySchedule', function() {
    return {
        restrict: 'E',
        scope: {
            bars: '='
        },
        templateUrl: 'assets/directives/weeklySchedule.html'
    };
});