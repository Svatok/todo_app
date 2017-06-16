(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .factory('Comment', Comment);

    function Comment(railsResourceFactory, railsSerializer, Upload, $http) {
      var resource = railsResourceFactory({
        url: '/api/todos/{{todoId}}/items/{{itemId}}/comments/{{id}}',
    		name: 'comment'
      });

      resource.uploadComment = function (text, attachment, item) {
        var uploaded = Upload.upload({
          url: '/api/todos/' + item.todoId + '/items/' + item.id + '/comments',
          data: {
            comment_text: text,
            attachment: attachment
          }
        });
    		return uploaded;
    	};

      resource.deleteComment = function (id, item) {
        var deleted = $http.delete('/api/todos/' + item.todoId
                                  + '/items/' + item.id
                                  + '/comments/' + id
                      );
    		return deleted;
    	};

      return resource;
    };

})();
