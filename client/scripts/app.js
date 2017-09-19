'use strict';

angular
  .module('clientAppApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ui.router',
    'ngSanitize',
    'ngTouch',
    'rails',
    'ng-token-auth',
    'xeditable',
    'ui.sortable',
    'ui.bootstrap',
    'ui.bootstrap.datetimepicker',
    'ngFileUpload',
    'ngFlash',
    'angularSpinner',
    'ngMessages'
  ])
  .run(function(editableOptions) {
    editableOptions.theme = 'bs3';
  });
