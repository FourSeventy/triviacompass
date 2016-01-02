app.directive('weeklySchedule', function() {
    return {
        restrict: 'E',
        scope: false,
        templateUrl: window.template_path('weeklySchedule.html')
    };
});