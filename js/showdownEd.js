// Generated by CoffeeScript 1.4.0
var app;

app = angular.module('showdownEd', ['ngSanitize']);

app.controller('Editor', function($scope, $http, $sanitize) {
  var converter, updateHTML;
  converter = new Showdown.converter();
  $scope.haveFileSelected = false;
  $scope.currentMarkdown = '';
  $scope.files = [
    {
      name: 'demo.md'
    }, {
      name: 'demo2.md'
    }
  ];
  updateHTML = function(md) {
    var html;
    html = converter.makeHtml(md);
    $scope.currentMarkdown = angular.copy(md);
    return $scope.currentHtml = html;
  };
  $scope.updateMd = function(md) {
    return updateHTML(md);
  };
  $scope.selectFile = function() {
    var fn;
    fn = $scope.selectedFile.name;
    return $http({
      method: 'GET',
      url: 'markdown/' + fn
    }).success(function(data, status, headers, config) {
      $scope.haveFileSelected = true;
      updateHTML(data);
      $scope.currentMarkdown = data;
      return console.log($scope.currentMarkdown);
    });
  };
  return true;
});
