sliderPeriod = 3000
sliderMove = 1000

$(document).ready ->
	slideImages = [
		'1.jpg'
		'2.jpg'
		'3.jpg'
		'4.jpg'
	].map (fileName) -> "url(img/slider/#{fileName}"

	slideText = [
		'5 батутов'
		'Поролоновая яма'
		'Тренеры'
		'Оборудование'
	]

	$slider = $('#slider')

	for image, i in slideImages
		$slide = $('<div class="slide" />').prependTo $slider
		$title = $('<h1/>').text(slideText[i]).appendTo $slide
		$slide.css backgroundImage: image

	topSlide = ->
		$('#slider .slide:last-of-type')

	setInterval ->
			$slide = topSlide()
			new TweenMax.to $slide, sliderMove / 1000,
				css: opacity: 0
				onComplete: ->
					$slider.prepend $slide.detach().css opacity: 1
		,
			sliderPeriod
