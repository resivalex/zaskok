<div id="order-content">
	<div class="to-center clearfix">
		<div class="date-container">
			<div class="guests-title">Количество человек</div>
			<div class="guests-container">
				<div id="guests-count">
	 				<input type="radio" id="radio1" name="guests" value="1" checked="checked"><label for="radio1">1</label>
					{for $i = 2 to 6}
						<input type="radio" id="radio{$i}" name="guests" value="{$i}"><label for="radio{$i}">{$i}</label>
					{/for}
				</div>
				<div id="more-count">
					{for $i = 7 to 9}
						<input type="radio" id="radio{$i}" name="guests" value="{$i}"><label for="radio{$i}">{$i}</label>
					{/for}
					<input type="radio" id="radio10" name="guests" value="10"><label for="radio10">Аренда</label>
				</div>
			</div>
			<div class="duration-title">Длительность</div>
			<div class="duration-container">
				<div id="duration-count">
					<input type="radio" id="radioo1" name="duration" value="10"><label for="radioo1">10 минут</label>
					<input type="radio" id="radioo2" name="duration" value="30" checked="checked"><label for="radioo2">30 минут</label>
					<input type="radio" id="radioo3" name="duration" value="60"><label for="radioo3">60 минут</label>
					<input type="radio" id="radioo4" name="duration" value="120"><label for="radioo4">2 часа</label>
				</div>
			</div>
			<div class="date-title">Дата</div>
			<div id="datepicker"></div>
		</div>
		<div class="recall">
			<div class="time-title">Время</div>
			<div class="time-table-container">
				<table id="time-table">
					{for $i = 10 to 21}
						<tr>
							{$lead = '0'}
							{for $j = 0 to 50 step=10}
								<td>
									<input type="radio" id="radi-{$i}-{$j}" name="time" value="{$i * 60 + $j}"><label for="radi-{$i}-{$j}">{$i}:{$lead}{$j}</label>
								</td>
								{$lead = ''}
							{/for}
						</tr>
					{/for}
				</table>
				<div class="loading">
					<div class="text">Загрузка...</div>
				</div>
			</div>
			<input id="order-button" type="button" value="Оставить заявку" />
			<p class="order-note">Чтобы оставить заявку необходимо<br>авторизоваться и заполнить номер телефона</p>
		</div>
	</div>
	<table class="record">
		<tr>
			<td colspan="2">Вы записаны</td>
		</tr>
		<tr>
			<td>Дата</td><td class="date">------</td>
		</tr>
		<tr>
			<td>Количество человек</td><td class="guests">------</td>
		</tr>
		<tr>
			<td>Время</td><td class="time">------</td>
		</tr>
		<tr>
			<td>Длительность</td><td class="duration">------</td>
		</tr>
		<tr>
			<td>Контактный телефон</td><td class="phone">------</td>
		</tr>
		<tr>
			<td colspan="2"><input id="token" type="hidden" value=""><button id="cancel-button">Отменить заявку</button></td>
		</tr>
	</table>
	<div class="login-container">
		<div class="vk-button">Войти через VK</div>
		<input class="phone" type="text" name="phone" placeholder="Номер телефона"/>
	</div>
</div>