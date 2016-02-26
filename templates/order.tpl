{literal}
<div id="order-content" ng-app="orderApp" ng-controller="OrderCtrl">
	<div class="to-center clearfix">
		<div id="instruction">
			Для записи обязательно авторизоваться на сайте<br/>
			и указать свой контактный телефон.<br/>
			<br/>
			Ниже выберите детали заявки
			<ul>
				<li>День посещения</li>
				<li>Точное количество человек</li>
				<li>Длительность посещения</li>
				<li>Точное время прибытия</li>
				<li>Нажмите "Оставить заявку"</li>
			</ul>
		</div>
		<div class="login-container">
			<div class="vk-button" my-vk ng-model="vkLoggedIn">{{vkButtonText}}</div>
			<input class="phone" type="text" placeholder="Номер телефона" ng-model="order.phone"/>
		</div>
		<div class="date-container">
			<div class="guests-title">Количество человек - {{order.guests}}</div>
			<div class="guests-container" my-buttonset>
				<div id="guests-count">
					<div ng-repeat="row in [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]">
		 				<div ng-repeat="i in row" style="display:inline-block;">
							<input type="radio" id="radio{{i}}" ng-model="order.guests" ng-value="{{i}}">
							<label for="radio{{i}}">{{i | guestsRentFormat}}</label>
						</div>
					</div>
				</div>
			</div>
			<div class="duration-title">Длительность - {{order.duration | durationFormat}}</div>
			<div class="duration-container">
				<div id="duration-count" my-buttonset>
					<div style="display:inline-block;" ng-repeat="dur in [10, 30, 60, 120]">
						<input id="dur-{{dur}}"
								type="radio" ng-model="order.duration" value={{dur}} ng-value="{{dur}}">
						<label for="dur-{{dur}}">{{dur | durationFormat}}</label>
					</div>
				</div>
			</div>
			<div class="date-title">Дата - {{order.date | dateFormat:true}}</div>
			<div id="datepicker" my-datepicker="datepickerOptions" ng-model="order.date"></div>
		</div>
		<div class="recall">
			<div class="time-title">Время - {{order.time | timeFormat}}</div>
			<div class="time-table-container">
				<div class="warning" ng-init="timeDelta"
						ng-show="timeDelta != 0">
					Ваше время в другом часовом поясе!
					<span ng-show="timeDelta > 0">+</span>{{timeDelta}} минут
				</div>
				<table id="time-table" my-buttonfield="availableTime" ng-model="order.time">
					<tr ng-repeat="hour in hours" ng-model="availableTime">
						<td ng-repeat="minute in minutes">
							<input type="radio" id="radi-{{hour}}-{{minute}}"
									ng-model="order.time" ng-value="{{hour * 60 + minute}}" disabled="disabled">
							<label for="radi-{{hour}}-{{minute}}">{{hour * 60 + minute | timeFormat}}</label>
						</td>
					</tr>
				</table>
				<div class="loading" ng-show="placeIsLoading">
					<div class="text">Загрузка...</div>
				</div>
			</div>
			<button id="order-button" type="button" ng-click="addRecord()" my-button>Оставить заявку</button>
			<p class="order-note"
				ng-model="orderNote"
				ng-init="orderNote = 'Чтобы оставить заявку необходимо авторизоваться и заполнить номер телефона'">
				{{orderNote}}</p>
		</div>
	</div>
	<table class="record" ng-show="record">
		<tr><td colspan="2">Вы записаны</td></tr>
		<tr><td>Дата</td><td>{{record.date | dateFormat}}</td></tr>
		<tr><td>Время</td><td>{{record.time | timeFormat}}</td></tr>
		<tr><td>Количество человек</td><td>{{record.guests | guestsRentFormat:true}}</td></tr>
		<tr><td>Длительность</td><td>{{record.duration | durationFormat}}</td></tr>
		<tr><td>Контактный телефон</td><td>{{record.phone}}</td></tr>
		<tr><td colspan="2">
			<button id="cancel-button" ng-click="removeRecord()" my-button>Отменить заявку</button>
		</td></tr>
	</table>
</div>
{/literal}