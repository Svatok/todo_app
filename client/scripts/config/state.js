(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .config(config);

    function config($stateProvider, $urlRouterProvider, $locationProvider) {
      $locationProvider.html5Mode(true);
      $stateProvider
        .state('auth', {
          url: '/auth',
          abstract: true,
          template: '<ui-view>'
        })
        .state('auth.signin', {
          url: '/sign_in',
          templateUrl: '/views/signin.html'
        })
        .state('auth.signup', {
          url: '/sign_up',
          templateUrl: '/views/signup.html'
        })
        .state('auth.resetPass', {
          url: '/reset_pass',
          templateUrl: '/views/reset_pass.html'
        })
        .state('changePass', {
          url: '/change_pass',
          templateUrl: '/views/change_pass.html',
          resolve: {
            access: function($auth, $state) {
              return $auth.validateUser().then(function () {
                  return true;
                }, function () {
                  return $state.go('auth.signin');
                });
            }
          }
        })
        .state('home', {
          url: '/',
          templateUrl: '/views/todos.html',
          resolve: {
            access: function($auth, $state) {
              return $auth.validateUser().then(function () {
                  return true;
                }, function () {
                  return $state.go('auth.signin');
                });
            }
          }
        });
      $urlRouterProvider.otherwise('/');
    };

})();
