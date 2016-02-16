$ ->
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

	# месяца в склонении
	monthNames2 = []
	for name in monthNames
		monthNames2.push switch name
			when "Март", "Август" then name + 'а'
			else name.substring(0, name.length - 1) + 'я'

	outDate = (date) ->
		dateVar = new Date(date)
		msInDay = 1000 * 3600 * 24
		dateStr = "#{dateVar.getDate()} #{monthNames2[dateVar.getMonth()]}"
		dateStr = 'Завтра' if dateVar.getTime() - new Date().getTime() < msInDay
		dateStr = 'Сегодня' if dateVar.getTime() - new Date().getTime() < 0
		$('#order-content .date-title').text dateStr

	$('#datepicker').datepicker(
		monthNames: monthNames
		dayNamesMin: [
			'Вс'
			'Пн'
			'Вт'
			'Ср'
			'Чт'
			'Пт'
			'Сб'
		]
		firstDay: 1
		minDate: new Date()
		onSelect: (date) ->
			outDate date
	)
	outDate $('#datepicker').datepicker('getDate')

	$('#guests-count').buttonset()

	outSliderTime = (value) ->
		clock = switch value
			when 21 then 'час'
			when 22, 23 then 'часа'
			else 'часов'
		$('#order-content .time-display').text("Буду в #{value} #{clock}")

	# $('#time-slider').slider(
	# 	value: 12
	# 	min: 10
	# 	max: 23
	# 	step: 1
	# 	slide: (event, ui) ->
	# 		outSliderTime ui.value
	# )
	# outSliderTime $('#time-slider').slider('value')

	$('#more-count').buttonset()
	$('#duration-count').buttonset()
	$('#order-button').button()
	$('#time-table').buttonset()