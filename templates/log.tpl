{* templates *}

{* <div style="display:none;">
	<table id="records" class="records">
		<tr><td>Дата</td><td>Время</td><td>Кол-во</td><td>Длительность</td><td>Пользователь</td><td>Телефон</td><td></td></tr>
	</table>

	<table>
		<tr id="records-row">
			<td class="date"></td>
			<td class="time"></td>
			<td class="guests"></td>
			<td class="duration"></td>
			<td class="user"><a></a></td>
			<td class="phone"></td>
			<td class="delete"><input type="hidden"/><button>Удалить заявку</button></td>
		</tr>
	</table>
</div>
 *}
{* page *}
<header>
	<label class="page-title">Администрирование</label><a class="logout" href="/php/logout.php">Выход</a>
</header>
{* <div id="report"></div>
<div id="add-record">
	<table>
		<tr>
			<td>Дата</td>
		</tr>
	</table>
</div>
 *}

{literal}
<div ng-app="adminApp">


<div class="report" ng-controller="ReportCtrl">
	<table ng-if="records.length">
		<tr ng-init="titles = ['Дата', 'Время', 'Кол-во', 'Длительность', 'Пользователь', 'Телефон', 'Действие']">
			<td ng-repeat="title in titles">{{title}}</td>
		</tr>
		<tr ng-repeat="record in records">
			<td>{{record.date}}</td>
			<td>{{record.time}}</td>
			<td>{{record.guests}}</td>
			<td>{{record.duration}}</td>
			<td ng-if="record.first_name != null"><a href="http://vk.com/{{record.domain}}">{{record.user}}</a></td>
			<td ng-if="record.first_name == null">{{record.user}}</td>
			<td>{{record.phone}}</td>
			<td><button ng-click="removeRecord()">Удалить</button></td>
		</tr>
	</table>
	<label ng-if="records.length == 0">Нет записей</label>
</div>
<div class="add-record" ng-controller="AddRecordCtrl">
	<table>
		<tr>
			<td>Дата</td><td><input ng-model="date"/></td>
		</tr>
		<tr>
			<td>Время</td><td><select ng-model="time" ng-options="opt for opt in timeOptions"></select></td>
		</tr>
		<tr>
			<td>Кол-во</td><td><input ng-model="guests"/></td>
		</tr>
		<tr>
			<td>Длительность</td><td><input ng-model="duration"/></td>
		</tr>
		<tr>
			<td>Пользователь</td><td><input ng-model="user_name"/></td>
		</tr>
		<tr>
			<td>Телефон</td><td><input ng-model="phone"/></td>
		</tr>
		<tr>
			<td colspan="2"><button ng-click="save()">Добавить запись</button></td>
		</tr>
	</table>
</div>


</div>
{/literal}