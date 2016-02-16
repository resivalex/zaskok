<!-- Авторизация ВКонтакте -->
<script src="//vk.com/js/api/openapi.js" type="text/javascript"></script>
<script src="js/vk.js" language="javascript"></script>

<div id="order-content">
	<div class="to-center clearfix">
		<div class="date-container">
			<div class="guests-title">Количество человек</div>
			<div class="guests-container">
				<div id="guests-count">
	 				<input type="radio" id="radio1" name="radio" checked="checked"><label for="radio1">1</label>
					{for $i = 2 to 5}
						<input type="radio" id="radio{$i}" name="radio"><label for="radio{$i}">{$i}</label>
					{/for}
				</div>
				<div id="more-count">
					{for $i = 6 to 9}
						<input type="radio" id="radio{$i}" name="radio"><label for="radio{$i}">{$i}</label>
					{/for}
					<input type="radio" id="radio10" name="radio"><label for="radio10">Аренда</label>
				</div>
			</div>
			<div class="duration-title">Длительность</div>
			<div class="duration-container">
				<div id="duration-count">
					<input type="radio" id="radioo1" name="radio2"><label for="radioo1">10 минут</label>
					<input type="radio" id="radioo2" name="radio2" checked="checked"><label for="radioo2">30 минут</label>
					<input type="radio" id="radioo3" name="radio2"><label for="radioo3">60 минут</label>
					<input type="radio" id="radioo4" name="radio2"><label for="radioo4">2 часа</label>
				</div>
			</div>
			<div class="date-title">Дата</div>
			<div id="datepicker"></div>
		</div>
		<div class="recall">
			<div class="time-title">Время</div>
			<table id="time-table">
				{for $i = 10 to 21}
					<tr>
						{$lead = '0'}
						{for $j = 0 to 50 step=10}
							<td>
								<input type="radio" id="radi-{$i}-{$j}" name="radio2"><label for="radi-{$i}-{$j}">{$i}-{$lead}{$j}</label>
							</td>
							{$lead = ''}
						{/for}
					</tr>
				{/for}
			</table>
			<input id="order-button" type="button" value="Оставить заявку" />
			<p class="order-note">Чтобы оставить заявку необходимо<br>авторизоваться и заполнить номер телефона</p>
		</div>
	</div>
	<div class="login-container">
		<div class="vk-button">Загрузка...</div>
		<input class="phone" type="text" placeholder="Номер телефона"/>
	</div>
</div>