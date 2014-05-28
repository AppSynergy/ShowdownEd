app = angular.module('showdownEd', ['ngSanitize'])

app.controller 'Editor', ($scope, $http, $sanitize, $sce) ->
	
	# Showdown Converter
	converter = new Showdown.converter()
	
	# We haven't chosen a file yet
	$scope.haveFileSelected = false
	$scope.markdown = {
		current: '',
		original: '',
		diff: '',
		html: '',
	}
	
	# ---------------------------------------------
	# Demo files - replace with proper interface
	# ---------------------------------------------
	$scope.files = [
		{name:'demo.md'},
		{name:'demo2.md'},
	]
	
	# ---------------------------------------------
	# Calculate diff between the current markdown
	# and the original markdown.
	# @param md String
	# @return Html
	# ---------------------------------------------
	createMarkdownDiff = (md) ->
		oldtxt = difflib.stringAsLines $scope.markdown.original
		newtxt = difflib.stringAsLines md
		sm = new difflib.SequenceMatcher oldtxt, newtxt
		opcodes = sm.get_opcodes()
		return diffview.buildView {
			baseTextLines: oldtxt,
			newTextLines: newtxt,
			opcodes: opcodes,
			baseTextName: "Original Text",
			newTextName: "New Text",
			contextSize: 0,
			viewType: 0,
		}

	# ---------------------------------------------
	# Listens to updates to markdown
	# @param md String
	# ---------------------------------------------
	$scope.updateMd = (md) ->
		$scope.markdown.html = converter.makeHtml md
		$scope.markdown.diff = createMarkdownDiff md
		return
	
	# ---------------------------------------------
	# Strict contextual escaping for HTML
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
				$scope.markdown.current = data
				$scope.markdown.original = data
				$scope.updateMd data
				$scope.editor.$setPristine()
	
	# ---------------------------------------------
	# Default controller return value
	true
