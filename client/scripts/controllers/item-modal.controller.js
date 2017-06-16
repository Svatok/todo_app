(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .controller('ItemModalCtrl', ItemModalCtrl);

    function ItemModalCtrl($scope, $uibModalInstance, item, Comment, usSpinnerService) {

      var vm = this;

      vm.showSpinner = false;

      vm.status = {
        opened: false
      };

      if (item.deadline){
        vm.deadline = new Date(item.deadline);
      };

      var commentQuery = function(){
        Comment.get({todoId: item.todoId, itemId: item.id}).then(function(comments){
          vm.comments = comments;
        });
      };

      commentQuery();

      vm.open = function($event) {
        vm.status.opened = true;
      };

      $scope.$watch('im.deadline', function(newValue, oldValue) {
        if ((oldValue != newValue)) {
          item.deadline = (newValue) ? toTimeZone(newValue) : '';
          item.update();
        };
      });

      vm.addComment = function(){
        vm.showSpinner = true;
        Comment.uploadComment(vm.commentText, vm.attachment, item).then(
          function (comment) {
            vm.comments.push(prepareComment(comment));
            vm.showSpinner = false;
        });
        vm.commentText = '';
        vm.attachment = '';
        $scope.AddCommentForm.$setPristine();
      };

      vm.removeComment = function (comment) {
        var index = vm.comments.indexOf(comment);
        if (!confirm('Are you sure you want to delete this comment?')) { return; };
        vm.showSpinner = true;
        Comment.deleteComment(comment.id, item).then(
          function () {
            vm.comments.splice(index, 1);
            vm.showSpinner = false;
        });
      };

      var toTimeZone = function(date){
        date.setHours(date.getHours() + 12);
        date.setMinutes(date.getMinutes() - date.getTimezoneOffset());
        return date.toISOString().substring(0,10);
      };

      var camelize = function (str) {
        var arr = str.split('_');
        for (var i = 1; i < arr.length; i++) {
          arr[i] = arr[i].charAt(0).toUpperCase() + arr[i].slice(1);
        }
        return arr.join('');
      };

      var prepareComment = function (answer) {
        var newComment = {};
        angular.forEach(answer.data, function(value, key) {
          newComment[camelize(key)] = value;
        });
        return newComment;
      };

    };

})();
