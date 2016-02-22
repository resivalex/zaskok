app = angular.module 'adminApp', []

app.controller 'ReportCtrl', ($scope, $http) ->
	$scope.records = []

	refreshReport = ->
		$http.post '/php/admin.php', action: 'getAllRecords'
			.success (data) ->
				console.log data
				records = []
				for index, record of data
					if record.firstName != null
						record['user'] = "#{record.firstName} #{record.lastName}"
					else
						record['user'] = record.userName

					records.push record
				$scope.records = records
			.error (data) -> console.log 'error'

	refreshReport()

	$scope.removeRecord = ->
		if confirm 'Удалить?'
			$http.post '/php/admin.php',
					action: 'removeRecordByToken'
					token: @.record.token
				.success (data) -> console.log data; refreshReport()
				.error (data) -> console.log 'error'

app.controller 'AddRecordCtrl', ($scope, $http) ->
	$scope.timeOptions = ("#{Math.floor(time / 60)}:#{time % 60}" for time in [10 * 60 ... 22 * 60] by 10)
	console.log $scope.timeOptions
	$scope.save = ->
		console.log @.phone
		$http.post '/php/admin.php',
			action: 'addRecord'
			record:
				date: @.date
				time: @.time
				guests: @.guests
				duration: @.duration
				userName: @.userName
				phone: @.phone
		.success ->
			refreshReport()
		.error (data) -> console.log 'error'