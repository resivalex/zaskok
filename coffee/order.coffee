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
monthNameOf = (monthName) ->
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

VK.init
	apiId: apiId
	# status: true

###
Data functions
###

requestJSON = (url, data, onSuccess, onFail) ->
	$.ajax {method: 'post', url, data}
	.done (response) ->
		try
			result = $.parseJSON response
		catch e
			onFail formatError
			console.log formatError, response
			return
		onSuccess result
	.fail -> onFail serverError

getUserRecord = (onSuccess, onFail) ->
	requestJSON '/php/user.php', action: 'getUserRecord', onSuccess, onFail

getUserPhone = (user, onSuccess, onFail) ->
	requestJSON '/php/user.php', action: 'getUserPhone', onSuccess, onFail

addRecordRequest = (record, onSuccess, onFail) ->
	requestJSON '/php/record.php', record, onSuccess, onFail

removeRecordRequest = (token, onSuccess, onFail) ->
	requestJSON '/php/unrecord.php', token: token, onSuccess, onFail

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

getPlaceInformation = (posixDate, onSuccess, onFail) ->
	requestJSON '/php/user.php', {action: 'getPlaceMapByDate', date: posixDate}, onSuccess, onFail

###
GUI functions
###

refreshButton = ->
	$button = $('#order-content .vk-button')
	checkLoginStatus (session) ->
			$button.text 'Загрузка...'
			getSessionUser session, (user) ->
				text =
					if user then "#{user.first_name} #{user.last_name} (выход)"
					else 'Ошибка'
				$button.text text
		, ->
			$button.text 'Войти через VK'

placeGlobal = []
recordGlobal = null

getSelectedGuests = -> parseInt($('#order-content input[name=guests]:checked').val())
getSelectedDuration = -> parseInt($('#order-content input[name=duration]:checked').val())
getSelectedDate = -> $('#datepicker').datepicker('getDate')

refreshButton()

VK.Observer.subscribe 'auth.statusChange', refreshButton
VK.Observer.subscribe 'auth.logout', hideRecord
VK.Observer.subscribe 'auth.login', ->
	checkLoginStatus (session) ->
			getSessionUser session, (user) ->
				console.log 'user', user
				getUserPhone user, (response) ->
						console.log 'phone', response.phone
						$('#order-content input[name=phone]').val response.phone
					,
						(msg) -> console.log msg

			getUserRecord (response) ->
					if typeof(response) == 'object'
						console.log 'record', response
						if response.token != undefined
							displayRecord response
				,
					(msg) -> console.log msg

		, (msg) -> console.log 'Must be loggined, but isn\'t'



$(document).on 'click', '.vk-button', ->
	checkLoginStatus ->
			VK.Auth.logout()
		, ->
			VK.Auth.login()

$ ->

	# $('#order-content .duration-container').on 'click', highlightPlace
	# $('#order-content .guests-container').on 'click', highlightPlace
	$('#order-content input[name=guests][value='+maxGuests+']').on 'change', ->
		recheck = false
		if $(@).is(':checked')
			$durationButtons = $('#order-content input[name=duration]')
			$durationButtons.each ->
				if $(@).val() < 60 # hour
					$(@).button('disable')
					if $(@).is(':checked')
						recheck = true
				else
					if recheck
						$(@).prop checked: true
						recheck = false
			$durationButtons.each ->
				$(@).button('refresh')

	$('#order-content input[name=guests][value!='+maxGuests+']').on 'change', ->
		$('#order-content input[name=duration]').each ->
			$(@).button('enable')

	outDate = (date) ->
		dateVar = new Date(date)
		dateStr = "#{dateVar.getDate()} #{monthNameOf(monthNames[dateVar.getMonth()])}"
		dateStr = 'Завтра' if dateVar.getTime() - new Date().getTime() < msInDay
		dateStr = 'Сегодня' if dateVar.getTime() - new Date().getTime() < 0
		$('#order-content .date-title').text dateStr

	dayNames = russianDayNames
	dayNames.unshift dayNames[dayNames.length - 1]
	now = new Date()
	$('#datepicker').datepicker(
		monthNames: monthNames
		dayNamesMin: dayNames
		firstDay: 1
		minDate: new Date(now.getTime() + if now.getHours() * 60 + now.getMinutes() >= closeTime then msInDay else 0)
		maxDate: new Date(now.getTime() + maxOrderIntervalDays * msInDay)
		onSelect: (date) ->
			console.log date
			$scope = $(@).scope()
			$scope.$apply ->
				$scope.selectDate new Date(date)
			# outDate date
			# reloadTimeTable new Date(date)
	)

	setOrderNote = (text) -> $('#order-content .order-note').text text

	$('#order-button').on 'click', ->
		# record =
		# 	guests: getSelectedGuests()
		# 	duration: getSelectedDuration()
		# 	datetime: Math.round(getSelectedDate().getTime() / 1000) +
		# 		parseInt($('#order-content input[name=time]:checked').val() * 60)
		# 	phone: $('#order-content input[name=phone]').val()
		# console.log record
		# if recordGlobal
		# 	setOrderNote 'Вы уже оставили заявку'
		# 	return

		# validateRecord record,
		# 	->
		# 		setOrderNote 'Проверка авторизации...'
		# 		checkLoginStatus ->
		# 				$('#order-button').button('disable')
		# 				setOrderNote 'Отправка...'
		# 				addRecordRequest record, (record) ->
		# 						if typeof(record) == 'object'
		# 							setOrderNote 'Запись успешно произведена!'
		# 							displayRecord record
		# 						else
		# 							setOrderNote record
		# 						$('#order-button').button('enable')
		# 					,
		# 						(msg) ->
		# 							setOrderNote msg
		# 							$('#order-button').button('enable')
		# 			,
		# 				-> setOrderNote 'Необходима авторизация через VK'
		# 	,
		# 	(msg) -> setOrderNote msg

	$('#cancel-button').on 'click', ->
		token = $('#token').val()
		removeRecordRequest token,
				-> hideRecord()
				(msg) -> console.log msg



app = angular.module 'orderApp', []
	.filter 'dateFormat', ->
		(input) ->
			dateStr = "#{input.getDate()} #{monthNameOf(monthNames[input.getMonth()])}"
			dateStr = 'Завтра' if input.getTime() - new Date().getTime() < msInDay
			dateStr = 'Сегодня' if input.getTime() - new Date().getTime() < 0
			dateStr
	.filter 'checkmark', ->
		(input) ->
			if input then '\u2713' else '\u2718'
	.directive 'datepicker', ->
		restrict: 'A'
		require: 'ngModel'
		link: (scope, elem, attrs, ngModelCtrl) ->
			updateModel = (dateText) ->
				scope.$apply ->
					ngModelCtrl.$setViewValue dateText

			options
				dateFormat: "dd/mm/yy"
				onSelect: (dateText) ->
					updateModel dateText

			elem.datepicker options

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
					showOn:"both",
					changeYear:true,
					changeMonth:true,
					dateFormat:'yy-mm-dd',
					maxDate: new Date(),
					yearRange: '1920:2012',
					onSelect: (dateText, inst) ->
						scope.$apply (scope) ->
							ngModel.assign(scope, dateText);



app.controller 'OrderCtrl', ($scope, $http) ->
	$scope.hours = [10..21]
	$scope.minutes = (i * 10 for i in [0..5])

	$scope.timeFormat = (hour, minute) -> "#{hour}:" + if minute == 0 then "00" else "#{minute}"

	$scope.selectedDate = $('#datepicker').datepicker('getDate')
	$scope.arr1 = [2, 3, 4, 5, 6]
	$scope.arr2 = [7, 8, 9]

	$scope.selectedDate = new Date('01/01/2015')

	$scope.durationOptions = [
			value: 10
			name: '10 минут'
		,
			value: 30
			name: '30 минут'
		,
			value: 60
			name: '60 минут'
		,
			value: 120
			name: '2 часа'
	]

	$scope.order =
		guests: 2
		duration: 30
		date: new Date()
		time: null

	$scope.availableTime = (false for i in [1..72])

	$scope.place = (0 for i in [1..72])

	$scope.$watchGroup ['order.guests', 'order.duration', 'place'], ->
		temp = new Array(72, false)
		for i in [0...72]
			temp[i] = Math.round Math.random()
		console.log $scope.order
		console.log $scope.place
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

	$scope.$watchCollections

	$scope.duration = value: 30

	$scope.placeIsLoading = true

	$scope.selectDate = (date) ->
		$scope.selectedDate = date
		$scope.reloadTimeTable(date)

	$scope.reloadTimeTable = (date) ->
		$scope.placeIsLoading = true
		posixDate = Math.round date.getTime() / 1000
		$http.post '/php/user.php',
			action: 'getPlaceMapByDate'
			date: posixDate

		.success (response) ->
			console.log 'place', response
			$scope.place = response
			$scope.placeIsLoading = false

		.error (err) -> console.log err

	$scope.addRecord = ->
		console.log 'order', $scope.order

	$scope.reloadTimeTable(new Date())