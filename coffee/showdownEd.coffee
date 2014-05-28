app = angular.module('showdownEd', ['ngSanitize'])

app.controller 'Editor', ($scope, $http, $sanitize, $sce) ->
	
	# Showdown Converter
	converter = new Showdown.converter()
	
	# We haven't chosen a file yet
	$scope.haveFileSelected = false
	$scope.markdown = {
		current: '',
		original: '',
	}
	
	# ---------------------------------------------
	# Demo files - replace with proper interface
	# ---------------------------------------------
	$scope.files = [
		{name:'demo.md'},
		{name:'demo2.md'},
	]
	
	# ---------------------------------------------
	# Update HTML variable
	# @param md String
	# ---------------------------------------------
	updateHtml = (md) ->
		html = converter.makeHtml md
		$scope.markdown.current = angular.copy md
		$scope.htmlPreview = html
	
	# ---------------------------------------------
	# Calculate diff between the current markdown
	# and the original markdown.
	# @return Html
	# ---------------------------------------------
	diffMd = () ->
		oldtxt = difflib.stringAsLines $scope.markdown.original
		newtxt = difflib.stringAsLines $scope.markdown.current
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
		#console.log scope.markdown.current
	
	# ---------------------------------------------
	# Listens to updates to markdown
	# @param md String
	# ---------------------------------------------
	$scope.updateMd = (md) ->
		updateHtml md
		$scope.mdDiffView = diffMd()
		return
	
	# ---------------------------------------------
	# Strict contextual escaping for DiffView
	# @param html Html
	# @return String
	# ---------------------------------------------
	$scope.toTrusted = (html) ->
		return $sce.trustAsHtml html.outerHTML
	
	# ---------------------------------------------
	# Select a file to edit
	# ---------------------------------------------
	$scope.selectFile = () ->
		#console.log $scope.selectedFile
		fn = $scope.selectedFile.name
		$http({method: 'GET', url: 'markdown/'+fn})
			.success (data, status, headers, config) =>
				$scope.haveFileSelected = true
				updateHtml data
				$scope.markdown.current = data
				$scope.markdown.original = data
				$scope.editor.$setPristine()
	
	# ---------------------------------------------
	# Default controller return value
	true
