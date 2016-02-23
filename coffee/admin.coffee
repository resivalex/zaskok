app = angular.module 'adminApp', ['myFormats', 'myDirectives']
.factory 'shared', ->
	date = null
	dateFns = []
	recFns = []

	onDateChanged = (fn) ->
		dateFns.push fn

	setDate = (dt) ->
		date = dt
		fn(date) for fn in dateFns

	getDate = -> date

	recordsChanged = ->
		fn() for fn in recFns

	onRecordsChanged = (fn) ->
		recFns.push fn

	{
		onDateChanged
		setDate
		getDate
		recordsChanged
		onRecordsChanged
	}


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

app.controller 'ReportCtrl', ['$scope', '$http', 'shared', ($scope, $http, shared) ->
	$scope.records = []
	$scope.users = []

	$scope.reports = [
			name: 'Записи'
		,
			name: 'Пользователи'
	]
	$scope.currentReport = index: 0

	refreshReport = ->
		postRequest $http,
			data:
				action: 'getRecordsByDate'
				date: window.toPosixDate shared.getDate()
			success: (response) ->
				records = []
				for index, record of response
					if record.firstName
						record['user'] = "#{record.firstName} #{record.lastName}"
					else
						record['user'] = record.userName

					records.push record

				$scope.records = records

		postRequest $http,
			data:
				action: 'getUsers'
			success: (response) ->
				$scope.users = response

	refreshReport()

	$scope.removeRecord = ->
		if confirm 'Удалить?'
			postRequest $http,
				data:
					action: 'removeRecord'
					token: @.record.token
				finally: ->
					refreshReport()
					shared.recordsChanged()

	shared.onDateChanged refreshReport
	shared.onRecordsChanged refreshReport
]

app.controller 'AddRecordCtrl', ['$scope', '$http', 'shared', ($scope, $http, shared) ->
	$scope.datepickerOptions = {}
	$scope.record =
		date: new Date()
		guests: 2
		duration: 30

	$scope.note = ""

	$scope.hours = [10...22]
	$scope.minutes = (i for i in [0...60] by 10)

	$scope.place = (0 for i in [0...72])
	$scope.availableTime = (false for i in $scope.place)

	refreshPlaces = (date) ->
		$http.post '/php/user.php',
			action: 'getPlaceMapByDate',
			date: window.toPosixDate date
		.then (response) ->
			$scope.place = response.data.data

	shared.setDate new Date()

	setInterval ->
			refreshPlaces shared.getDate()
			shared.recordsChanged()
		, 10000

	$scope.$watch 'record.date', (date) ->
		refreshPlaces date
		shared.setDate date

	shared.onRecordsChanged ->
		refreshPlaces shared.getDate()

	$scope.$watchGroup ['place', 'record.date', 'record.guests', 'record.duration'], ->
		$scope.availableTime = window.availablePlaces $scope.place,
			$scope.record.date, $scope.record.guests, $scope.record.duration, true

	$scope.$watch 'availableTime', ->
		if $scope.record.time and not $scope.availableTime[($scope.record.time - 10 * 60) / 10]
			$scope.record.time = null

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
						datetime: window.toPosixDate(record.date) + record.time * 60
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
					$scope.record.time = null
					shared.setDate shared.getDate()
					shared.recordsChanged()
]