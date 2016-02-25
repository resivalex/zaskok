navHeight = -> $('nav').height()

isMobile = navigator.userAgent.match(/Android/i) or
	navigator.userAgent.match(/webOS/i) or
	navigator.userAgent.match(/iPhone/i) or
	navigator.userAgent.match(/iPad/i) or
	navigator.userAgent.match(/iPod/i) or
	navigator.userAgent.match(/BlackBerry/i) or
	navigator.userAgent.match(/Windows Phone/i)

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
	# $('.popup').each ->
	# 	el = @
	# 	onVisibilityChanged(@,
	# 		-> TweenMax.to el, 0.6 + Math.random() * 0.4, y: 0,
	# 		-> TweenMax.to el, 0, y: popupShift,
	# 	)

	xyRandOffset = (popupShift) ->
		css:
			left: (Math.random() - 0.5) * popupShift
			top: (Math.random() - 0.5) * popupShift

	if not isMobile and window.innerWidth >= 600
		$('.rand-popup').each ->
			el = @
			onVisibilityChanged(el,
				-> TweenMax.to el, 0.6 + Math.random() * 0.4, xyRandOffset(0)
				,
				-> TweenMax.to el, 0.6 + Math.random() * 0.4, xyRandOffset(100)
			)

		# animate facts
		$('.fact').each ->
			el = @
			onVisibilityChanged(@,
				# -> TweenMax.to el, 1, x: 0,
				# -> TweenMax.to el, 0, x: $(document).width() / 4
				-> TweenMax.to el, 1, css: opacity: 1,
				-> TweenMax.to el, 0, css: opacity: 0
			)

		$('.fade-out').each ->
			el = @
			onVisibilityChanged(@,
				-> TweenMax.to el, 1, css: opacity: 1,
				-> TweenMax.to el, 0, css: opacity: 0
			)

		

	$('.menu-logo')
		.on 'click', ->
			$('html, body').animate scrollTop: 0, 500

	$('.gallery').lightGallery(thumbnail: true)