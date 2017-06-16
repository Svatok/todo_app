(function() {
'use strict';

angular
  .module('clientAppApp')
  .controller('ItemsCtrl', ItemsCtrl);

  function ItemsCtrl($scope, $uibModal, Item, Flash) {

    var vm = this;
    vm.parentTodo = $scope.todo;

    vm.addTodoItem = function(todo){
      if (!vm.beforeSaveItem(todo.newItemName)) { return; };
      var newItem = {name: todo.newItemName, done: false, todoId: todo.id}
      new Item(newItem).create().then(function (item) {
        todo.items.splice(0, 0, item);
      });
      todo.newItemName = '';
    };

    vm.beforeSaveItem = function (data) {
      if (!data) {
        Flash.create('danger', 'Task name must be present!');
        return false;
      };
      return true;
    };

    vm.updateItem = function(item){
      item.update();
    };

    vm.toggleDone = function (item) {
      item.done = !item.done;
      item.update().then(function () {}, function (errors) {
        Flash.create('danger', Object.values(errors.data).join('<br/>'));
      });
    };

    vm.removeTodoItem = function (item) {
      if (!confirm('Are you sure you want to delete this task?')) { return; }
      var index = vm.parentTodo.items.indexOf(item);
      item.delete().then(function () {
        vm.parentTodo.items.splice(index, 1);
      }, function (errors) {
        Flash.create('danger', Object.values(errors.data).join('<br/>'));
      });
    };

    vm.sortableOptions = {
      stop: function(e, ui) {
        angular.forEach(vm.parentTodo.items, function(item, newPosition) {
          if (item.position != newPosition) {
            item.position = newPosition;
            item.update().then(function () {}, function (errors) {
              Flash.create('danger', Object.values(errors.data).join('<br/>'));
            });
          }
        });
      }
    };

    vm.open = function (_item) {
      var modalInstance = $uibModal.open({
        controller: 'ItemModalCtrl',
        controllerAs: 'im',
        templateUrl: 'views/item_modal.html',
        resolve: {
          item: function() { return _item; }
        }
      });
    };
  };
})();
