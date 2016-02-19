app = angular.module 'app', []

app.controller 'ReportCtrl', ($scope, $http) ->
	$scope.records = []

	refreshReport = ->
		$http.post '/php/angular.php', report: 'all_records'
			.success (data) ->
				console.log data
				records = []
				for index, record of data
					if record.first_name != null
						record['user'] = "#{record.first_name} #{record.last_name}"
					else
						record['user'] = record.user_name

					records.push record
				$scope.records = records
			.error (data) -> console.log 'error'

	refreshReport()

	$scope.removeRecord = ->
		$http.post '/php/angular.php',
				action: 'remove_record'
				token: @.record.token
			.success (data) -> console.log data; refreshReport()
			.error (data) -> console.log 'error'

app.controller 'AddRecordCtrl', ($scope, $http) ->
	$scope.timeOptions = ("#{Math.floor(time / 60)}:#{time % 60}" for time in [10 * 60 ... 22 * 60] by 10)
	console.log $scope.timeOptions
	$scope.save = ->
		console.log @.phone