(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .config(config);

    function config($authProvider) {

      $authProvider
        .configure({
          apiUrl: '/api',
          passwordResetSuccessUrl: window.location.origin,
          omniauthWindowType: 'newWindow',
          authProviderPaths: {
            facebook: '/auth/facebook'
          }
        });
    };

})();
