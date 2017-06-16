(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .factory('Todo', Todo);

    function Todo(railsResourceFactory, railsSerializer) {
    	return railsResourceFactory({
    		url: '/api/todos/{{id}}',
    		name: 'todo',
    		serializer: railsSerializer(function () {
    			this.resource('items', 'Item');
    		})
    	});
    };

})();
