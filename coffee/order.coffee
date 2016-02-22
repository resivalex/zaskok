###
Constants
###

apiId = 5297183
openTime = 10 * 60 # 10:00
closeTime = 22 * 60 # 22:00
timeDelta = 10 # minutes
maxGuests = 10
durationIntervals = [10, 30, 60, 120]
formatError = 'Не удалось распознать ответ'
serverError = 'Ошибка сервера'

msInDay = 1000 * 3600 * 24
maxOrderIntervalDays = 7

monthNames = [
	'Январь'
	'Февраль'
	'Март'
	'Апрель'
	'Май'
	'Июнь'
	'Июль'
	'Август'
	'Сентябрь'
	'Октябрь'
	'Ноябрь'
	'Декабрь'
]

russianDayNames = [
	'Пн'
	'Вт'
	'Ср'
	'Чт'
	'Пт'
	'Сб'
	'Вс'
]

# месяц в родительном падеже
monthNameOf = (index) ->
	monthName = monthNames[index]
	switch monthName
		when "Март", "Август" then monthName + 'а'
		else monthName.substring(0, monthName.length - 1) + 'я'

###
VK functions
###

checkLoginStatus = (onlineHandler, offlineHandler) ->
	VK.Auth.getLoginStatus (response) ->
		if response.session
			console.log response
			onlineHandler(response.session)
		else
			offlineHandler()

getSessionUser = (session, func) ->
	VK.Api.call 'users.get', {user_ids: session.mid, fields: ['domain']}, (r) ->
		user = null
		if r.response
			user = r.response[0]
		func(user)

initVk = ->
	VK.init
		apiId: apiId

###
Data functions
###

validateRecord = (record, onSuccess, onFail) ->
	typeConditions = [
		-> typeof(record) == 'object'
		-> typeof(record.guests) == 'number'
		-> typeof(record.duration) == 'number'
		-> typeof(record.datetime) == 'number'
		-> typeof(record.phone) == 'string'
	]
	valueConditions = [
			func: -> record.guests >= 1 && record.guests <= maxGuests
			msg: "Неверно указано кол-во человек"
		,
			func: -> durationIntervals.indexOf(record.duration) != -1
			msg: "Неверно указана длительность"
		,
			func: ->
				nowPosixMsec = (new Date()).getTime()
				recordMs = record.datetime * 1000
				min = Math.floor(nowPosixMsec / msInDay) * msInDay
				max = nowPosixMsec + (maxOrderIntervalDays + 1) * msInDay
				min < recordMs && recordMs < max
			msg: "Не выбрано время"
		,
			func: -> record.phone != ''
			msg: 'Не указан номер телефона'
		,
			func: -> record.phone.match /([0-9].*){5,}/
			msg: 'Некорректный номер телефона'
	]
	for condition in typeConditions
		if not condition()
			onFail 'TypeError in validateRecord'
			return
	for condition in valueConditions
		if not condition.func()
			onFail condition.msg
			return
	onSuccess()

###
GUI functions
###

app = angular.module 'orderApp', []
	.filter 'dateFormat', ->
		(input, aliases = false) ->
			if input
				dateStr = "#{input.getDate()} #{monthNameOf(input.getMonth())}"
				if aliases
					dateStr = 'Завтра' if input.getTime() - new Date().getTime() < msInDay
					dateStr = 'Сегодня' if input.getTime() - new Date().getTime() < 0
				dateStr
			else
				'?'

	.filter 'timeFormat', ->
		(input) ->
			if input
				temp = parseInt(input)
				hour = Math.floor temp / 60
				minute = temp - 60 * hour
				"#{hour}:" + if minute == 0 then "00" else "#{minute}"
			else
				'?'

	.filter 'durationFormat', ->
		(input) ->
			if input
				if input <= 60
					"#{input} минут"
				else
					"#{input / 60} часа"
			else
				'?'

	.filter 'guestsRentFormat', ->
		(input) ->
			if parseInt(input) == 10
				'Аренда'
			else
				input

	.directive 'myButtonfield', ($parse) ->
		(scope, element, attrs, controller) ->
			ngModel = $parse(attrs.ngModel)
			$ ->
				element.find('[type=radio]').each ->
					$(@).button()

				scope.$watch attrs.myButtonfield, ->
					element.find('[type=radio]').each (index) ->
						if not eval("scope.#{attrs.myButtonfield}")[index]
							if $(@).is(':checked')
								console.log 'ok'
								$(@).attr 'checked', false
								eval("scope.#{attrs.ngModel} = null")
							$(@).attr 'checked', false
							$(@).button 'disable'
						else
							$(@).button 'enable'
					element.find('[type=radio]').each (index) ->
						$(@).button 'refresh'

				element.on 'change', '[type=radio]', ->
					element.find('[type=radio]').each (index) ->
						$(@).button 'refresh'

	.directive 'myButtonset', ($parse) ->
		(scope, element, attrs, controller) ->
			ngModel = $parse(attrs.ngModel)
			$ ->
				element.buttonset()
				element.on 'change', '[type=radio]', ->
					element.buttonset 'refresh'

	.directive 'myButton', ($parse) ->
		(scope, element) ->
			$ ->
				element.button()

			
	.directive 'myDatepicker', ($parse) ->
		(scope, element, attrs, controller) ->
			ngModel = $parse(attrs.ngModel)
			console.log 'scope', scope
			$ ->
				element.datepicker
					showOn:"both"
					changeYear:true
					changeMonth:true
					dateFormat:'yy-mm-dd'
					maxDate: new Date()
					yearRange: '1920:2012'
					onSelect: (dateText, inst) ->
						scope.$apply (scope) ->
							ngModel.assign(scope, dateText)

	.directive 'myVk', ($parse) ->
		(scope, element, attrs) ->
			ngModel = $parse(attrs.ngModel)
			$ ->
				initVk()

				element.on 'click', ->
					checkLoginStatus ->
							VK.Auth.logout()
						, ->
							VK.Auth.login()
	
				VK.Observer.subscribe 'auth.logout', ->
					scope.$apply (scope) ->
						ngModel.assign scope, false

				VK.Observer.subscribe 'auth.login', ->
					scope.$apply (scope) ->
						ngModel.assign scope, true




app.controller 'OrderCtrl', ($scope, $http) ->
	$scope.hours = [10..21]
	$scope.minutes = (i * 10 for i in [0..5])

	$scope.order =
		guests: 2
		duration: 30
		date: new Date()
		time: null
		phone: ''

	$scope.availableTime = (false for i in [1..72])

	$scope.place = (0 for i in [1..72])

	$scope.$watchGroup ['order.guests', 'order.duration', 'place'], ->
		temp = new Array(72, false)

		guests = $scope.order.guests
		duration = parseInt $scope.order.duration
		date = $scope.order.date
		isToday = date.getDate() == (new Date()).getDate() && date.getMonth() == (new Date()).getMonth()
		minutesNow = (new Date()).getHours() * 60 + (new Date()).getMinutes()

		for index in [0...72]
			enabled = on 
			time = openTime + index * timeDelta
			if time + duration > closeTime
				enabled = off
			if isToday && time < minutesNow
				enabled = off
			countInDelta = duration / timeDelta
			for i in [index...Math.min(index + countInDelta, $scope.place.length)]
				if $scope.place[i] + guests > maxGuests
					enabled = off
			temp[index] = enabled

		$scope.availableTime = temp

	$scope.$watch 'order.duration', (duration) ->
		$('#duration-count').buttonset()
		$('#duration-count').buttonset 'refresh'

	$scope.$watch 'order.guests', (guests) ->
		if guests == 10
			$scope.order.duration = Math.max $scope.order.duration, 60
			$('#duration-count input[type=radio]').each ->
				if $(@).val() < 60
					$(@).attr 'disabled', true
		else
			$('#duration-count input[type=radio]').each ->
				$(@).attr 'disabled', false
		$('#duration-count').buttonset 'refresh'

	$scope.duration = value: 30

	$scope.placeIsLoading = true

	postRequest = (requestOptions) ->
		$http.post '/php/user.php', requestOptions.data
		.then (response) ->
			if requestOptions.success
				requestOptions.success response.data.data
		.catch (response) ->
			if requestOptions.error
				requestOptions.error response
		.finally ->
			if requestOptions.finally
				requestOptions.finally()

	reloadTimeTable = (date) ->
		$scope.placeIsLoading = true
		posixDate = Math.round date.getTime() / 1000
		postRequest
			data:
				action: 'getPlaceMapByDate'
				date: posixDate
			success: (response) ->
				$scope.place = response
				$scope.placeIsLoading = false

	$scope.$watchGroup ['order.date', 'record'], -> reloadTimeTable $scope.order.date

	$scope.record = null

	setRecord = (record) ->
		if typeof(record) == 'object'
			dt = new Date(record.datetime * 1000)
			$scope.record =
				date: dt
				time: dt.getHours() * 60 + dt.getMinutes()
				guests: record.guests
				duration: record.duration
				phone: record.phone
				token: record.token
		else
			$scope.record = null

	$scope.addRecord = ->
		console.log 'order', $scope.order
		record =
			guests: $scope.order.guests
			duration: $scope.order.duration
			datetime: if $scope.order.date and $scope.order.time
					Math.round($scope.order.date.getTime() / 1000) + $scope.order.time * 60
				else 0
			phone: $scope.order.phone
		console.log record
		if $scope.record
			$scope.orderNote = 'Вы уже оставили заявку'
			return

		$scope.orderNote = 'Проверка авторизации...'
		checkLoginStatus ->
			validateRecord record,
				->
					$('#order-button').button('disable')
					$scope.orderNote = 'Отправка...'
					postRequest
						data:
							action: 'addRecord'
							record: record
						success: (response) ->
							if typeof(response) == 'object'
								$scope.orderNote = 'Запись успешно произведена!'
								setRecord response
							else
								$scope.orderNote = response
						error: (response) ->
							$scope.orderNote = response
						finally: ->
							$('#order-button').button('enable')
			,
				(msg) -> $scope.orderNote = msg
		,
			-> $scope.orderNote = 'Необходима авторизация через VK'

	$scope.removeRecord = ->
		if confirm 'Удалить заявку?'
			postRequest
				data:
					action: 'removeRecord'
					token: $scope.record.token
				success: (response) ->
					console.log response
					$scope.record = null

	dateDaysLater = (days) ->
		msNow = (new Date()).getTime()
		new Date(msNow + days * msInDay)

	dayNames = russianDayNames
	dayNames.unshift dayNames[dayNames.length - 1]
	now = new Date()
	closed = now.getHours() * 60 + now.getMinutes() >= closeTime
	$('#datepicker').datepicker(
		monthNames: monthNames
		dayNamesMin: dayNames
		firstDay: 1
		minDate: dateDaysLater(if closed then 1 else 0)
		maxDate: dateDaysLater(maxOrderIntervalDays)
		onSelect: (date) ->
			$scope.$apply ($scope) ->
				$scope.order.date = new Date(date)
	)

	$scope.order.date = $('#datepicker').datepicker 'getDate'

	$scope.vkLoggedIn = false
	$scope.vkButtonText = 'Войти через VK'

	$scope.$watch 'vkLoggedIn', (logged) ->
		checkLoginStatus (session) ->
				$scope.vkButtonText = 'Загрузка...'
				getSessionUser session, (user) ->
					text =
						if user then "#{user.first_name} #{user.last_name} (выход)"
						else 'Ошибка'
					$scope.$apply ($scope) ->
						$scope.vkButtonText = text

					postRequest
						data: action: 'getUserPhone'
						success: (response) ->
							console.log response
							if response.phone
								$scope.order.phone = response.phone

					postRequest
						data: action: 'getUserRecord'
						success: (response) ->
							console.log response
							setRecord response

					postRequest
						data:
							action: 'addUser'
							user:
								firstName: user.first_name
								lastName: user.last_name
								domain: user.domain
						success: (response) ->
							console.log 'addUser', response
			, ->
				$scope.record = null
				$scope.vkButtonText = 'Войти через VK'
