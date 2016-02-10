{* <!-- Авторизация ВКонтакте -->
<script src="//vk.com/js/api/openapi.js" type="text/javascript"></script>

<div id="vk-login-button" onclick="VK.Auth.login(authInfo);"></div>

<script language="javascript">
VK.init({
  apiId: 5273336
});
function authInfo(response) {
  if (response.session) {
    console.log('user: '+response.session.mid);
  } else {
    console.log('not auth');
  }
}
VK.Auth.getLoginStatus(authInfo);
VK.UI.button('vk-login-button');
</script> *}

<div id="order-content">
	<div class="recall popup">
		<div class="guests-title">Количество человек</div>
		<div id="guests-count">
			<input type="radio" id="radio1" name="radio" checked="checked"><label for="radio1">1</label>
			<input type="radio" id="radio2" name="radio"><label for="radio2">2</label>
			<input type="radio" id="radio3" name="radio"><label for="radio3">3</label>
			<input type="radio" id="radio4" name="radio"><label for="radio4">4</label>
			<input type="radio" id="radio5" name="radio"><label for="radio5">Больше</label>
		</div>
		<div class="time-display"></div>
		<div id="time-slider"></div>
		<input type="text" placeholder="Ваше имя" />
		<input type="text" placeholder="Ваш телефон" />
		<input type="button" value="Оставить заявку" />
	</div>
 	<div class="date-container popup">
		<div class="date-title">Дата</div>
		<div id="datepicker"></div>
	</div>
</div>