<header>
	<label class="page-title">Режим администратора</label><a class="logout" href="/php/logout.php">Выход</a>
</header>

{literal}
<div ng-app="adminApp">


<div class="add-record clearfix" ng-controller="AddRecordCtrl">
	<div class="date-time">
		<div id="datepicker" my-datepicker="datepickerOptions" ng-model="record.date"></div>
		<table class="time-grid">
			<tr ng-repeat="hour in hours">
				<td ng-repeat="minute in minutes">
					<input type="radio" id="time{{hour}}-{{minute}}"
						ng-model="record.time" ng-value="hour * 60 + minute" ng-disabled="hour < 13">
					<label for="time{{hour}}-{{minute}}">{{hour * 60 + minute | timeFormat}}</label>
				</td>
			</tr>
		</table>
	</div>
	<table class="add-form">
		<tr>
			<td>Кол-во</td><td>
				<div class="line-select">
					<div class="cell" ng-repeat="q in [1,2,3,4,5,6,7,8,9,10]">
						<input type="radio" id="qua{{q}}" ng-model="record.guests" ng-value="q">
						<label for="qua{{q}}">{{q | guestsRentFormat}}</label>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>Длительность</td><td>
				<div class="line-select">
					<div class="cell" ng-repeat="q in [10,30,60,120]">
						<input type="radio" id="dur{{q}}" ng-model="record.duration" ng-value="q">
						<label for="dur{{q}}">{{q | durationFormat}}</label>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>Имя</td><td><input ng-model="record.name"/></td>
		</tr>
		<tr>
			<td>Телефон</td><td><input ng-model="record.phone"/></td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
	</table>

	<table class="record-card">
		<tr>
			<td>{{record.date | dateFormat}}</td>
		<td>{{record.time | timeFormat}}</td>
		<td>{{record.duration | durationFormat}}</td>
		<td>{{record.guests | guestsRentFormat:true}}</td>
		<td>{{record.name}}&nbsp;</td>
		<td>{{record.phone}}&nbsp;</td>
		<td><button ng-click="save()" ng-disabled="isSaving">Добавить запись</button></td></tr>
	</table>
	<div class="note">{{note}}</div>

</div>

<div class="report" ng-controller="ReportCtrl">
	<div class="line-select">
		<div class="cell" ng-repeat="reportName in ['All records', 'Week statistics']">
			<input type="radio" id="report{{$index}}" ng-model="reportAbc">
			<label for="report{{$index}}">{{reportName}}</label>
		</div>
	</div>
	<table class="records" ng-show="records.length">
		<tr ng-init="titles = ['Дата', 'Время', 'Кол-во', 'Длительность', 'Пользователь', 'Телефон', 'Действие']">
			<td ng-repeat="title in titles">{{title}}</td>
		</tr>
		<tr ng-repeat="record in records">
			<td>{{record.date}}</td>
			<td>{{record.time}}</td>
			<td>{{record.guests}}</td>
			<td>{{record.duration}}</td>
			<td ng-show="record.firstName"><a href="http://vk.com/{{record.domain}}">{{record.user}}</a></td>
			<td ng-show="!record.firstName">{{record.user}}</td>
			<td>{{record.phone}}</td>
			<td class="delete"><button ng-click="removeRecord()">Удалить</button></td>
		</tr>
	</table>
	<label ng-show="records.length == 0">Нет записей</label>
</div>

</div>
{/literal}