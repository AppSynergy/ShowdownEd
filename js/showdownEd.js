// Generated by CoffeeScript 1.4.0
var app;

app = angular.module('showdownEd', ['ngSanitize']);

app.controller('Editor', function($scope, $http, $sanitize, $sce) {
  var converter, createMarkdownDiff;
  converter = new Showdown.converter();
  $scope.haveFileSelected = false;
  $scope.markdown = {
    current: '',
    original: '',
    diff: '',
    html: ''
  };
  $scope.files = [
    {
      name: 'demo.md'
    }, {
      name: 'demo2.md'
    }
  ];
  createMarkdownDiff = function(md) {
    var newtxt, oldtxt, opcodes, sm;
    oldtxt = difflib.stringAsLines($scope.markdown.original);
    newtxt = difflib.stringAsLines(md);
    sm = new difflib.SequenceMatcher(oldtxt, newtxt);
    opcodes = sm.get_opcodes();
    return diffview.buildView({
      baseTextLines: oldtxt,
      newTextLines: newtxt,
      opcodes: opcodes,
      baseTextName: "Original Text",
      newTextName: "New Text",
      contextSize: 0,
      viewType: 0
    });
  };
  $scope.updateMd = function(md) {
    $scope.markdown.html = converter.makeHtml(md);
    $scope.markdown.diff = createMarkdownDiff(md);
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
      $scope.markdown.current = data;
      $scope.markdown.original = data;
      $scope.updateMd(data);
      return $scope.editor.$setPristine();
    });
  };
  return true;
});
