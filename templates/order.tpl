{literal}
<div id="order-content" ng-app="orderApp" ng-controller="OrderCtrl">
	<div class="to-center clearfix">
		<div class="date-container">
			<div class="guests-title">Количество человек - {{order.guests}}</div>
			<div class="guests-container" my-buttonset>
				<div id="guests-count">
	 				<input type="radio" id="radio1" ng-model="order.guests" value="1">
	 				<label for="radio1">1</label>
	 				<div ng-repeat="i in arr1" style="display:inline-block;">
						<input type="radio" id="radio{{i}}" ng-model="order.guests" value="{{i}}">
						<label for="radio{{i}}">{{i}}</label>
					</div>
				</div>
				<div id="more-count">
					<div ng-repeat="i in arr2" style="display:inline-block;">
						<input type="radio" id="radio{{i}}" ng-model="order.guests" value="{{i}}">
						<label for="radio{{i}}">{{i}}</label>
					</div>
					<input type="radio" id="radio10" ng-model="order.guests" value="10">
					<label for="radio10">Аренда</label>
				</div>
			</div>
			<div class="duration-title">Длительность - {{order.duration}}</div>
			<div class="duration-container">
				<div id="duration-count" my-buttonset>
					<div style="display:inline-block;" ng-repeat="opt in durationOptions">
						<input id="dur-{{opt.value}}"
								type="radio" ng-model="order.duration" value="{{opt.value}}">
						<label for="dur-{{opt.value}}">{{opt.name}}</label>
					</div>
				</div>
			</div>
			<div class="date-title">{{selectedDate | dateFormat}}</div>
			<div id="datepicker"></div>
		</div>
		<div class="recall">
			<div class="time-title">Время - {{order.time}}</div>
			<div class="time-table-container">
				<table id="time-table" my-buttonfield="availableTime" ng-model="order.time">
					<tr ng-repeat="hour in hours" ng-model="availableTime">
						<td ng-repeat="minute in minutes">
							<input type="radio" id="radi-{{hour}}-{{minute}}"
									ng-model="order.time" value="{{hour * 60 + minute}}" disabled="disabled">
							<label for="radi-{{hour}}-{{minute}}">{{timeFormat(hour, minute)}}</label>
						</td>
					</tr>
				</table>
				<div class="loading" ng-show="placeIsLoading">
					<div class="text">Загрузка...</div>
				</div>
			</div>
			<input id="order-button" type="button" ng-click="addRecord()" value="Оставить заявку" my-button/>
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
			<td colspan="2"><input id="token" type="hidden" value="">
			<button id="cancel-button" my-button>Отменить заявку</button></td>
		</tr>
	</table>
	<div class="login-container">
		<div class="vk-button">Войти через VK</div>
		<input class="phone" type="text" name="phone" placeholder="Номер телефона" ng-model="availableTime"/>
	</div>
</div>
{/literal}