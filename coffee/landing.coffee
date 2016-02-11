navHeight = -> $('nav').height()

updateView = ->
	# make float menu
	$('.under-nav').css 'height', navHeight()
	$('nav').css position: 'fixed'

$window = $(window)
$window.on 'scroll resize', updateView
$(document).ready updateView

# link autoscrolling
$(document).on 'click', 'nav a', ->
	$('html, body').animate scrollTop: $($.attr(this, 'href') ).offset().top - navHeight(), 500
	false

$ ->
	monthNames = [
		"Январь"
		"Февраль"
		"Март"
		"Апрель"
		"Май"
		"Июнь"
		"Июль"
		"Август"
		"Сентябрь"
		"Октябрь"
		"Ноябрь"
		"Декабрь"
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
		dateStr = "Завтра" if dateVar.getTime() - new Date().getTime() < msInDay
		dateStr = "Сегодня" if dateVar.getTime() - new Date().getTime() < 0
		$('#order-content .date-title').text dateStr

	$('#datepicker').datepicker(
		monthNames: monthNames
		dayNamesMin: [
			"Вс"
			"Пн"
			"Вт"
			"Ср"
			"Чт"
			"Пт"
			"Сб"
		]
		firstDay: 1
		minDate: new Date()
		onSelect: (date) ->
			outDate date
	)
	outDate $('#datepicker').datepicker("getDate")

	$('#guests-count').buttonset()

	outSliderTime = (value) ->
		clock = switch value
			when 21 then "час"
			when 22, 23 then "часа"
			else "часов"
		$('#order-content .time-display').text("Буду в #{value} #{clock}")

	$('#time-slider').slider(
		value: 12
		min: 10
		max: 23
		step: 1
		slide: (event, ui) ->
			outSliderTime ui.value
	)
	outSliderTime $('#time-slider').slider('value')

	$sections = $('section')

	activeLink = (index) ->
		if index < 0
			$activeLink = $('.menu-logo')
		else
			id = $sections.eq(index).attr('id')
			$activeLink = $("nav a[href='##{id}']")


	activateSection = (index) ->
		$activeLink = activeLink(index)
		
		zoom = 0.9
		tuk = ->
			tl = new TimelineMax()
			tl.add TweenMax.to $activeLink, 0.1,
				css:
					scale: 0.95
			tl.add TweenMax.to $activeLink, 0.1,
				css:
					scale: 1

		TweenMax.to $activeLink, 0.2,
			className: '+=active'
			onComplete: tuk

	deactivateSection = (index) ->
		$activeLink = activeLink(index)

		TweenMax.to $activeLink, 0.2,
			className: '-=active'

	curIndex = -1
	activateSection(curIndex)

	# when active section has changed
	$sections.each (index) ->
		waypoint = new Waypoint(
			element: @
			handler: (direction) ->
				deactivateSection curIndex
				curIndex = if direction == 'down' then index else index - 1
				activateSection curIndex
			offset: '30%'
		)

	# universal method
	onVisibilityChanged = (el, onShow, onHide) ->
		onHide()
		new Waypoint(
			element: el
			handler: (direction) ->
				if direction == 'down'
					onShow()
				else
					onHide()
			offset: ->
				Waypoint.viewportHeight()
		)
		new Waypoint(
			element: el
			handler: (direction) ->
				if direction == 'down'
					onHide()
				else
					onShow()
			offset: -$(el).height() + navHeight()
		)

	# animate elements with class 'popup'
	popupShift = 100
	$('.popup').each ->
		el = @
		onVisibilityChanged(@,
			-> TweenMax.to el, 0.6 + Math.random() * 0.4, y: 0,
			-> TweenMax.to el, 0, y: popupShift,
		)

	xyRandOffset = ->
		x: (Math.random() - 0.5) * popupShift
		y: (Math.random() - 0.5) * popupShift

	$('.rand-popup').each ->
		el = @
		onVisibilityChanged(el,
			-> TweenMax.to el, 0.6 + Math.random() * 0.4, {x: 0, y: 0},
			-> TweenMax.to el, 0.6 + Math.random() * 0.4, xyRandOffset()
		)

	# animate facts
	$('.fact').each ->
		el = @
		onVisibilityChanged(@,
			-> TweenMax.to el, 1, x: 0,
			-> TweenMax.to el, 0, x: $(document).width() / 3
		)
		

	# hover logo element
	$('.menu-logo')
		.on 'mouseenter', ->
			console.log 'enter'
			TweenMax.to '.menu-logo', 0.1, css: scale: 1
		.on 'mouseout', ->
			TweenMax.to '.menu-logo', 0.1, css: scale: 1
		.on 'click', ->
			$('html, body').animate scrollTop: 0, 500

	$('.gallery').lightGallery(thumbnail: true)