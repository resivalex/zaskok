<header>
  <label class="page-title">Режим администратора</label><a class="logout" href="/php/logout.php">Выход</a>
</header>

{literal}
<div ng-app="adminApp">


<div class="add-record clearfix" ng-controller="AddRecordCtrl">
  <div class="date-time">
    <div id="datepicker" my-datepicker="datepickerOptions" ng-model="record.date"></div>
    <div class="time-box">
      <table class="time-grid" ng-model="availableTime">
        <tr ng-init="hIndex = $index" ng-repeat="hour in hours">
          <td ng-init="cellIndex = hIndex * 6 + $index" ng-repeat="minute in minutes">
            <input type="radio" id="time{{cellIndex}}"
              ng-model="record.time" ng-value="hour * 60 + minute"
              ng-disabled="!availableTime[cellIndex]">
            <label for="time{{cellIndex}}">{{hour * 60 + minute | timeFormat}}</label>
            <label class="place" ng-show="place[cellIndex] != 0">{{place[cellIndex]}}</label>
          </td>
        </tr>
      </table>
    </div>
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
    <div class="cell" ng-repeat="report in reports">
      <input type="radio" id="{{report.name}}" ng-model="currentReport.index" ng-value="$index">
      <label for="{{report.name}}">{{report.name}}</label>
    </div>
  </div>
  <div ng-show="currentReport.index == 0">
    <table class="records" ng-show="records.length">
      <tr ng-init="recordTitles = ['Дата', 'Время', 'Кол-во', 'Длительность', 'Пользователь', 'Телефон', 'Действие']">
        <td ng-repeat="title in recordTitles">{{title}}</td>
      </tr>
      <tr ng-repeat="record in records | orderBy:'':true">
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
  <div ng-show="currentReport.index == 1">
    <table class="users" ng-show="users.length">
      <tr ng-init="userTitles = ['Дата регистрации', 'Пользователь', 'Телефон']">
        <td ng-repeat="title in userTitles">{{title}}</td>
      </tr>
      <tr ng-repeat="user in users">
        <td>{{user.regDate}}</td>
        <td><a href="http://vk.com/{{user.domain}}">{{user.firstName}} {{user.lastName}}</a></td>
        <td>{{user.phone}}</td>
      </tr>
    </table>
    <label ng-show="users.length == 0">Нет пользователей</label>
  </div>
</div>

</div>
{/literal}