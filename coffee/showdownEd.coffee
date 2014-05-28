app = angular.module('showdownEd', ['ngSanitize'])

app.controller 'Editor', ($scope, $http, $sanitize, $sce) ->
	
	# Showdown Converter
	converter = new Showdown.converter()
	
	# We haven't chosen a file yet
	$scope.haveFileSelected = false
	$scope.currentMarkdown = ''
	$scope.mdDiffView = "<h1>pirates!</h1>"
	
	# Demo files - replace with proper interface
	$scope.files = [
		{name:'demo.md'},
		{name:'demo2.md'},
	]

	# Update HTML area based on .md input
	updateHtml = (md) ->
		html = converter.makeHtml md
		#console.log html
		$scope.currentMarkdown = angular.copy md
		$scope.currentHtml = html
	
	# Diff the text as we go along
	diffMd = () ->
		oldtxt = difflib.stringAsLines $scope.originalMarkdown
		newtxt = difflib.stringAsLines $scope.currentMarkdown
		console.log oldtxt
		console.log newtxt
		sm = new difflib.SequenceMatcher oldtxt, newtxt
		opcodes = sm.get_opcodes()
		return diffview.buildView {
			baseTextLines: oldtxt,
			newTextLines: newtxt,
			opcodes: opcodes,
			baseTextName: "Base Text",
			newTextName: "New Text",
			contextSize: 0,
			viewType: 0,
		}
		
	# Keep an eye on our scope
	#$scope.$watch (scope) ->
		#console.log scope.currentMarkdown
	
	# Update markdown
	$scope.updateMd = (md) ->
		#console.log md
		updateHtml md
		$scope.mdDiffView = diffMd()
		return
	
	# Strict contextual escaping
	$scope.toTrusted = (html) ->
		console.log html
		return $sce.trustAsHtml html.outerHTML
	
	# Select a file to edit
	$scope.selectFile = () ->
		#console.log $scope.selectedFile
		fn = $scope.selectedFile.name
		$http({method: 'GET', url: 'markdown/'+fn})
			.success (data, status, headers, config) =>
				$scope.haveFileSelected = true
				updateHtml data
				#if $scope.currentMarkdown.length > 0
				#	$scope.currentMarkdown = ''
				$scope.currentMarkdown = data
				$scope.originalMarkdown = data
				$scope.editor.$setPristine()
				$scope.mdDiffView = "<h1>zombies!</h1>"
				#$scope.editor.markdown = data
				#console.log $scope.currentMarkdown
	true
