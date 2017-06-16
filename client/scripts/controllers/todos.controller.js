(function() {
  'use strict';

  angular
    .module('clientAppApp')
    .controller('TodosCtrl', TodosCtrl);

    function TodosCtrl(Todo, Flash) {

      var vm = this;

      var todoQuery = function(){
        Todo.query().then(function(todos){
          vm.todos = todos;
        });
      };

      todoQuery();
      vm.title = '';
      vm.addTodoShow = false;

      vm.showAddTodo = function(){
        vm.addTodoShow = true;
      };
      vm.hideAddTodo = function(){
        vm.addTodoShow = false;
      };

      vm.addTodo = function(){
        new Todo({title: vm.title}).create().then(function (todo) {
          vm.todos.push(todo);
        });
        vm.title = '';
      };

      vm.beforeSaveTodo = function (data) {
        if (!data) {
          Flash.create('danger', 'Project title must be present!');
          return false;
        }
      };

      vm.updateTodo = function(todo){
        todo.update();
      };

      vm.sortableOptions = {
        stop: function(e, ui) {
          angular.forEach(vm.todos, function(todo, newPosition) {
            if (todo.position != newPosition) {
              todo.position = newPosition;
              todo.update().then(function () {}, function (errors) {
                Flash.create('danger', Object.values(errors.data).join('<br/>'));
              });
            }
          });
        }
      };

      vm.removeTodo = function (todo) {
        if (!confirm('Are you sure you want to delete this project?')) { return; }
        var index = vm.todos.indexOf(todo);
        todo.delete().then(function () {
          vm.todos.splice(index, 1);
        }, function (errors) {
          Flash.create('danger', Object.values(errors.data).join('<br/>'));
        });
      };

    };

})();
