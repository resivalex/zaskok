<form class="login-form" method="post">
	{if $is_wrong_password}
		<label>Неверный пароль!</label><br>
	{/if}
	<input type="password" name="password" placeholder="Пароль" />
	<input type="submit" value="Открыть журнал"/>
</form>