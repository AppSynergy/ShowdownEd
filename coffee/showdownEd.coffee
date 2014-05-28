app = angular.module('showdownEd', ['ngSanitize'])

app.controller 'Editor', ($scope, $http, $sanitize, $sce) ->
	
	# ---------------------------------------------
	# Substitute this for an actual server backend
	# ---------------------------------------------
	backendPath = "backend/"
	receiver = "receiver.php"
	
	# ---------------------------------------------
	# Main scope object
	# ---------------------------------------------
	$scope.markdown = {
		current: '',
		original: '',
		diff: '',
		html: '',
	}
	
	# ---------------------------------------------
	# Showdown Converter
	# ---------------------------------------------
	converter = new Showdown.converter()
	
	# ---------------------------------------------
	# Open without a file selected
	# ---------------------------------------------
	$scope.files = []
	$scope.haveFileSelected = false
	
	# ---------------------------------------------
	# Get the list of files we can edit
	# ---------------------------------------------	
	$http.get(backendPath+'files.json')
		.success (data) =>
			$scope.files = data.files
	
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
	# Assume we have a clean slate
	# @param md String
	# ---------------------------------------------
	setCleanForm = (md) ->
		$scope.markdown.current = md
		$scope.markdown.original = md
		$scope.updateMd md
		$scope.editor.$setPristine()

	# ---------------------------------------------
	# Select a file to edit
	# ---------------------------------------------
	$scope.selectFile = () ->
		fn = $scope.selectedFile.name
		$http.get(backendPath+'markdown/'+fn)
			.success (data, status, headers, config) =>
				$scope.haveFileSelected = true
				setCleanForm data
			.error (data, status, headers, config) =>
				console.log status+": file not found"
	
	# ---------------------------------------------
	# Submit the edited markdown
	# ---------------------------------------------
	$scope.submitMd = () ->
		sendData = {
			file: $scope.selectedFile.name
			content: $scope.markdown.current
		}
		$http.post(backendPath+receiver, sendData)
			.success (data, status, headers, config) =>
				setCleanForm $scope.markdown.current
				# Check the receiver is receiving
				console.log data
			.error (data, status, headers, config) =>
				console.log status+": save didn't happen"
	
	# ---------------------------------------------
	# Default controller return value
	true
