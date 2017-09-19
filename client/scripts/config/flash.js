(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .config(config);

    function config(FlashProvider) {
      FlashProvider.setTimeout(5000);
      FlashProvider.setShowClose(true);
    };

})();
