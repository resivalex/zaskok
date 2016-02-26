<form class="login-form" method="post">
  <input type="password" name="password" placeholder="Пароль" autofocus="true" />
  <input type="submit" value="Открыть журнал"/>
</form>
{if $isWrongPassword}
  <div class="wrong-password">Неверный пароль!</div>
{/if}
