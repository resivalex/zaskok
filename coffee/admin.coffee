app = angular.module 'adminApp', ['myFormats', 'myDirectives']

postRequest = ($http, requestOptions) ->
	onError = if requestOptions.error
			requestOptions.error
		else
			(response) ->
				console.log 'postRequest error: ' + response
	$http.post '/php/admin.php', requestOptions.data
	.then (response) ->
		if typeof(response.data) == 'object'
			if requestOptions.success
				requestOptions.success response.data.data
		else
			onError 'response.data has type ' + typeof(response.data) + '. It is ' + response.data
	.catch (response) ->
		onError response
	.finally ->
		if requestOptions.finally
			requestOptions.finally()

app.controller 'ReportCtrl', ($scope, $http) ->
	$scope.records = []
				
	refreshReport = ->
		postRequest $http,
			data: action: 'getAllRecords'
			success: (response) ->
				records = []
				for index, record of response
					if record.firstName
						record['user'] = "#{record.firstName} #{record.lastName}"
					else
						record['user'] = record.userName

					records.push record

				$scope.records = records

	refreshReport()

	$scope.removeRecord = ->
		if confirm 'Удалить?'
			postRequest $http,
				data:
					action: 'removeRecord'
					token: @.record.token

app.controller 'AddRecordCtrl', ($scope, $http) ->
	$scope.datepickerOptions = {}
	$scope.record =
		guests: 2
		duration: 30

	$scope.note = ""

	$scope.hours = [10...22]
	$scope.minutes = (i for i in [0...60] by 10)

	$scope.$watch 'record.guests', (guests) ->
		if guests == 10
			$scope.record.duration = Math.max $scope.record.duration, 60

	$scope.save = ->
		record = $scope.record
		if not record.time
			$scope.note = 'Время не выбрано'
		else if not record.name or not record.name.match /\S/
			$scope.note = 'Имя не указано'
		else
			$scope.isSaving = true
			postRequest $http,
				data:
					action: 'addRecord'
					record:
						datetime: Math.round(record.date.getTime() / 1000) + record.time * 60
						guests: record.guests
						duration: record.duration
						userName: record.name
						phone: record.phone
				success: (response) ->
					if typeof(response) == 'object'
						text = "Запись \"#{record.name}\" успешно добавлена!"
						record.name = null
						record.phone = null
					else
						text = response
					$scope.note = text
				error: ->
					$scope.note = 'Произошла ошибка'
				finally: ->
					$scope.isSaving = false