app = angular.module('showdownEd', ['ngSanitize'])

app.controller 'Editor', ($scope, $http, $sanitize) ->
	
	# Showdown Converter
	converter = new Showdown.converter()
	
	# We haven't chosen a file yet
	$scope.haveFileSelected = false
	$scope.currentMarkdown = ''
	
	# Demo files - replace with proper interface
	$scope.files = [
		{name:'demo.md'},
		{name:'demo2.md'},
	]

	# Update HTML area based on .md input
	updateHTML = (md) ->
		html = converter.makeHtml md
		#console.log html
		$scope.currentMarkdown = angular.copy md
		$scope.currentHtml = html

	# Update markdown
	$scope.updateMd = (md) ->
		#console.log md
		updateHTML md
	
	# Select a file to edit
	$scope.selectFile = () ->
		#console.log $scope.selectedFile
		fn = $scope.selectedFile.name
		$http({method: 'GET', url: 'markdown/'+fn})
			.success (data, status, headers, config) ->
				$scope.haveFileSelected = true
				updateHTML data
				$scope.currentMarkdown = data
				#$scope.editor.$setPristine()
				#$scope.editor.markdown = data
				console.log $scope.currentMarkdown
	true
