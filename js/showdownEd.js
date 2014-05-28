// Generated by CoffeeScript 1.4.0
var app;

app = angular.module('showdownEd', ['ngSanitize']);

app.controller('Editor', function($scope, $http, $sanitize, $sce) {
  var converter, diffMd, updateHtml;
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
  updateHtml = function(md) {
    var html;
    html = converter.makeHtml(md);
    $scope.currentMarkdown = angular.copy(md);
    return $scope.currentHtml = html;
  };
  diffMd = function() {
    var newtxt, oldtxt, opcodes, sm;
    oldtxt = difflib.stringAsLines($scope.originalMarkdown);
    newtxt = difflib.stringAsLines($scope.currentMarkdown);
    console.log(oldtxt);
    console.log(newtxt);
    sm = new difflib.SequenceMatcher(oldtxt, newtxt);
    opcodes = sm.get_opcodes();
    return diffview.buildView({
      baseTextLines: oldtxt,
      newTextLines: newtxt,
      opcodes: opcodes,
      baseTextName: "Base Text",
      newTextName: "New Text",
      contextSize: 0,
      viewType: 0
    });
  };
  $scope.updateMd = function(md) {
    updateHtml(md);
    $scope.mdDiffView = diffMd();
  };
  $scope.toTrusted = function(html) {
    return $sce.trustAsHtml(html.outerHTML);
  };
  $scope.selectFile = function() {
    var fn,
      _this = this;
    fn = $scope.selectedFile.name;
    return $http({
      method: 'GET',
      url: 'markdown/' + fn
    }).success(function(data, status, headers, config) {
      $scope.haveFileSelected = true;
      updateHtml(data);
      $scope.currentMarkdown = data;
      $scope.originalMarkdown = data;
      return $scope.editor.$setPristine();
    });
  };
  return true;
});
