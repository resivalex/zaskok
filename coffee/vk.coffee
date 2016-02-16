apiId = 5297183

loggedIn = false

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

VK.init
	apiId: apiId
	# status: true

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
