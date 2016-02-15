loggedIn = false

authInfo = (response) ->
	loggedIn = !!response.session
	if loggedIn
		# for i of response.session.user
		# 	console.log i, response.session.user[i]

		user = response.session.user
		# # console.log user.first_name, user.last_name
		try
			$('#order-content .vk-button').text "#{user.first_name} #{user.last_name}"
		catch e
			$('#order-content .vk-button').text "Can't get name"
		
	else
		$('#order-content .vk-button').text "Войти через VK"

VK.Auth.getLoginStatus authInfo

VK.init
	apiId: 5297183
	status: true

VK.Auth.getLoginStatus authInfo

# $(document).ready ->
	# VK.Auth.getLoginStatus(authInfo);
# VK.UI.button('vk-login-button');

$(document).on 'click', '.vk-button', ->
	if loggedIn
		VK.Auth.logout ->
			# VK.Auth.getLoginStatus authInfo 
	else
		VK.Auth.login (response) ->
			if response.session
				console.log 'ok'
				# VK.Auth.getLoginStatus authInfo
