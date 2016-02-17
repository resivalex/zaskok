###
Constants
###

apiId = 5297183
openTime = 10 * 60 # 10:00
closeTime = 22 * 60 # 22:00
timeDelta = 10 # minutes
maxGuests = 10
durationIntervals = [10, 30, 60, 120]

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
addRecordRequest = (record, onApply, onFail) ->
	$.ajax
		method: 'post'
		url: '/record.php'
		data: record
	.done (response) ->
		if response == ''
			onApply()
		else
			onFail response
	.fail -> onFail 'Ошибка'

createRecord = (guests, duration, datetime, phone) ->
	{
		guests
		duration
		datetime
		phone
	}

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
				console.log 'first line'
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
			func: -> record.phone.match /([0-9].*){4,}/
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
	$.ajax
		method: 'post'
		url: '/place.php'
		data: posixDate
	.done (response) ->
		try
			place = $.parseJSON(response)
		catch e
			onFail()
			return
		onSuccess(place)
	.fail onFail

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

getSelectedGuests = -> parseInt($('#order-content input[name=guests]:checked').val())
getSelectedDuration = -> parseInt($('#order-content input[name=duration]:checked').val())
getSelectedDate = -> $('#datepicker').datepicker('getDate')

highlightPlace = ->
	console.log 'highlightPlace'
	guests = getSelectedGuests()
	duration = getSelectedDuration()
	date = getSelectedDate()
	isToday = date.getDate() == (new Date()).getDate() && date.getMonth() == (new Date()).getMonth()
	console.log date, new Date()
	minutesNow = (new Date()).getHours() * 60 + (new Date()).getMinutes()

	$buttons = $('#time-table input[name=time]')
	$buttons.each (index) ->
		enabled = on
		time = openTime + index * timeDelta
		if time + duration > closeTime
			enabled = off
		if isToday && time < minutesNow
			enabled = off
		countInDelta = duration / timeDelta
		for i in [index...Math.min(index + countInDelta, placeGlobal.length)]
			if placeGlobal[i] + guests > maxGuests
				enabled = off
		$(@).button(if enabled then 'enable' else 'disable')
		if not enabled
			$(@).attr 'checked', false
			$(@).button('refresh')

reloadTimeTable = (date) ->
	$('#order-content .loading .text').text 'Загрузка...'
	$('#order-content .loading').css display: 'block'
	getPlaceInformation Math.floor(date.getTime() / 1000),
		(place) ->
			$('#order-content .loading').css display: 'none'
			$('#time-table input[name=time]').button('enable')
			placeGlobal = place
			highlightPlace()
		, -> $('#order-content .loading .text').text 'Ошибка'

refreshButton()

VK.Observer.subscribe 'auth.statusChange', refreshButton
VK.Observer.subscribe 'auth.login', ->
	checkLoginStatus (session) ->
		getSessionUser session, (user) ->
			console.log user
			$.ajax
				method: 'post',
				url: '/auth.php',
				data: user
			.done (response) -> console.log response
			.fail -> console.log 'fail'

$(document).on 'click', '.vk-button', ->
	checkLoginStatus ->
			VK.Auth.logout()
		, ->
			VK.Auth.login()

$ ->

	$('#order-content .duration-container').on 'click', highlightPlace
	$('#order-content .guests-container').on 'click', highlightPlace
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
			outDate date
			reloadTimeTable new Date(date)
	)
	outDate getSelectedDate()
	reloadTimeTable getSelectedDate()

	$('#guests-count').buttonset()
	$('#more-count').buttonset()
	$('#duration-count').buttonset()
	$('#order-button').button()
	$('#time-table input[name=time]').button()

	setOrderNote = (text) -> $('#order-content .order-note').text text

	$('#order-button').on 'click', ->
		record =
			guests: getSelectedGuests()
			duration: getSelectedDuration()
			datetime: Math.round(getSelectedDate().getTime() / 1000) +
				parseInt($('#order-content input[name=time]:checked').val())
			phone: $('#order-content input[name=phone]').val()
		console.log record
		validateRecord record,
			->
				setOrderNote 'Проверка авторизации...'
				checkLoginStatus ->
						$('#order-button').button('disable')
						setOrderNote 'Отправка...'
						addRecordRequest record, ->
								setOrderNote 'Запись успешно произведена!'
							,
								(msg) ->
									setOrderNote msg
									$('#order-button').button('enable')
					,
						-> setOrderNote 'Необходима авторизация через VK'
			,
			(msg) -> setOrderNote msg
