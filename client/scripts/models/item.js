(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .factory('Item', Item);

    function Item(railsResourceFactory, railsSerializer) {
      return railsResourceFactory({
    		url: '/api/todos/{{todoId}}/items/{{id}}',
    		name: 'item',
        serializer: railsSerializer(function () {
    			this.resource('comments', 'Comment');
    		})
      });
    };

})();
