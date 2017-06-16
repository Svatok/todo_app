(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .controller('AuthCtrl', AuthCtrl);

    function AuthCtrl($auth, $rootScope, $state, Flash) {

      var vm = this;

      vm.showSignUp = function() {
        $state.go('auth.signup');
      };

      vm.resetPass = false;

      vm.showSignIn = function() {
        $state.go('auth.signin');
      };

      vm.showResetPass = function() {
        $state.go('auth.resetPass');
      };

      $rootScope.$on('auth:validation-success', function() {
        if (!vm.resetPass) {
          return $state.go('home');
        }
        vm.resetPass = false;
      });

      $rootScope.$on('auth:login-success', function(ev, user) {
        $state.go('home');
      });

      $rootScope.$on('auth:login-error', function(ev, reason) {
        Flash.create('danger', reason.errors.join('<br/>'));
      });

      $rootScope.$on('auth:logout-success', function(ev) {
        $state.go('auth.signin');
      });

      $rootScope.$on('auth:registration-email-success', function(ev, message) {
        $state.go('home');
      });

      $rootScope.$on('auth:registration-email-error', function(ev, reason) {
        Flash.create('danger', reason.errors.full_messages.join('<br/>'));
      });

      $rootScope.$on('auth:password-reset-request-success', function(ev, data) {
        Flash.create('success', 'Password reset instructions were sent to ' + data.email);
      });

      $rootScope.$on('auth:password-reset-confirm-success', function() {
        vm.resetPass = true;
        $state.go('changePass');
      });

      $rootScope.$on('auth:password-change-success', function(ev) {
        Flash.create('success', 'Your password has been successfully updated!');
        $state.go('home');
      });

      $rootScope.$on('auth:password-change-error', function(ev, reason) {
        Flash.create('danger', 'Password changing failed: ' + reason.errors[0]);
      });
    };

})();
