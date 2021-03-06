###
Constants
###

openTime = 10 * 60 # 10:00
closeTime = 22 * 60 # 22:00
timeDelta = 10 # minutes
maxGuests = 10
durationIntervals = [10, 30, 60, 120]
formatError = 'Не удалось распознать ответ'
serverError = 'Ошибка сервера'

secInDay = 3600 * 24
msInDay = secInDay * 1000
maxOrderIntervalDays = 7

russianDayNames = [
    'Пн'
    'Вт'
    'Ср'
    'Чт'
    'Пт'
    'Сб'
    'Вс'
]

monthNames = [
    'Январь'
    'Февраль'
    'Март'
    'Апрель'
    'Май'
    'Июнь'
    'Июль'
    'Август'
    'Сентябрь'
    'Октябрь'
    'Ноябрь'
    'Декабрь'
]

###
VK functions
###

checkLoginStatus = (onlineHandler, offlineHandler) ->
    VK.Auth.getLoginStatus (response) ->
        if response.session
            console.log response
            onlineHandler(response.session)
        else
            offlineHandler()

getSessionUser = (session, func) ->
    VK.Api.call 'users.get', {user_ids: session.mid, fields: ['domain']}, (r) ->
        user = null
        if r.response
            user = r.response[0]
        func(user)

# initVk = ->
#   VK.init
#       apiId: apiId

###
Data functions
###

validateRecord = (record, onSuccess, onFail) ->
    typeConditions = [
        -> typeof(record) == 'object'
        -> typeof(record.guests) == 'number'
        -> typeof(record.duration) == 'number'
        -> typeof(record.datetime) == 'number'
        -> typeof(record.phone) == 'string'
    ]
    valueConditions = [
            func: -> record.guests >= 1 && record.guests <= maxGuests
            msg: "Неверно указано кол-во человек"
        ,
            func: -> durationIntervals.indexOf(record.duration) != -1
            msg: "Неверно указана длительность"
        ,
            func: ->
                nowSamaraTime = window.toSamaraDate new Date()
                recordTime = window.toSamaraDate new Date(record.datetime * 1000)
                min = Math.floor(nowSamaraTime / secInDay) * secInDay
                max = nowSamaraTime + (maxOrderIntervalDays + 1) * secInDay
                min < recordTime && recordTime < max
            msg: "Не выбрано время"
        ,
            func: -> record.phone != ''
            msg: 'Не указан номер телефона'
        ,
            func: -> record.phone.match /([0-9].*){5,}/
            msg: 'Некорректный номер телефона'
    ]
    for condition in typeConditions
        if not condition()
            onFail 'TypeError in validateRecord'
            return
    for condition in valueConditions
        if not condition.func()
            onFail condition.msg
            return
    onSuccess()




angular.module 'orderApp', ['myFormats', 'myDirectives']
.controller 'OrderCtrl', ($scope, $http) ->
    $scope.hours = [10..21]
    $scope.minutes = (i * 10 for i in [0..5])
    $scope.timeDelta = -240 - new Date().getTimezoneOffset()

    $scope.order =
        guests: 2
        duration: 30
        date: new Date()
        time: null
        phone: ''

    $scope.availableTime = (false for i in [1..72])

    $scope.place = (0 for i in [1..72])

    $scope.$watchGroup ['order.guests', 'order.duration', 'place'], ->
        $scope.availableTime =
            window.availablePlaces $scope.place,
                    $scope.order.date, $scope.order.guests, $scope.order.duration

    $scope.$watch 'order.duration', (duration) ->
        $('#duration-count').buttonset()
        $('#duration-count').buttonset 'refresh'

    $scope.$watch 'order.guests', (guests) ->
        if guests == 10
            $scope.order.duration = Math.max $scope.order.duration, 60
            $('#duration-count input[type=radio]').each ->
                if $(@).val() < 60
                    $(@).attr 'disabled', true
        else
            $('#duration-count input[type=radio]').each ->
                $(@).attr 'disabled', false
        $('#duration-count').buttonset 'refresh'

    $scope.duration = value: 30

    $scope.placeIsLoading = true

    postRequest = (requestOptions) ->
        onError = if requestOptions.error
                requestOptions.error
            else
                (response) ->
                    console.log 'postRequest error: ', response
        $http.post '/php/user.php', requestOptions.data
        .then (response) ->
            if typeof(response.data) == 'object'
                if requestOptions.success
                    requestOptions.success response.data.data
            else
                onError 'response.data has type ' + typeof(response.data) + '. It is ' + response.data
        .catch (response) ->
            onError response
        .finally ->
            if requestOptions.finally
                requestOptions.finally()

    reloadTimeTable = (date) ->
        $scope.placeIsLoading = true
        postRequest
            data:
                action: 'getPlaceMapByDate'
                date: window.toSamaraDate date
            success: (response) ->
                console.log 'place', response
                $scope.place = response
                $scope.placeIsLoading = false

    $scope.$watchGroup ['order.date', 'record'], -> reloadTimeTable $scope.order.date

    $scope.record = null

    setRecord = (record) ->
        if typeof(record) == 'object'
            dt = window.fromSamaraDate(record.datetime)
            $scope.record =
                date: dt
                time: dt.getHours() * 60 + dt.getMinutes()
                guests: record.guests
                duration: record.duration
                phone: record.phone
                token: record.token
        else
            $scope.record = null

    $scope.addRecord = ->
        console.log 'order', $scope.order
        record =
            guests: $scope.order.guests
            duration: $scope.order.duration
            datetime: if $scope.order.date and $scope.order.time
                    window.toSamaraDate($scope.order.date) + $scope.order.time * 60
                else 0
            phone: $scope.order.phone
        console.log record
        if $scope.record
            $scope.orderNote = 'Вы уже оставили заявку'
            return

        $scope.orderNote = 'Проверка авторизации...'
        checkLoginStatus ->
            validateRecord record,
                ->
                    $('#order-button').button('disable')
                    $scope.orderNote = 'Отправка...'
                    postRequest
                        data:
                            action: 'addRecord'
                            record: record
                        success: (response) ->
                            if typeof(response) == 'object'
                                $scope.orderNote = 'Запись успешно произведена!'
                                setRecord response
                            else
                                $scope.orderNote = response
                        error: (response) ->
                            $scope.orderNote = response
                        finally: ->
                            $('#order-button').button('enable')
            ,
                (msg) -> $scope.orderNote = msg
        ,
            -> $scope.orderNote = 'Необходима авторизация через VK'

    $scope.removeRecord = ->
        if confirm 'Удалить заявку?'
            postRequest
                data:
                    action: 'removeRecord'
                    token: $scope.record.token
                success: (response) ->
                    console.log response
                    $scope.record = null

    dateDaysLater = (days) ->
        msNow = (new Date()).getTime()
        new Date(msNow + days * msInDay)

    dayNames = russianDayNames
    dayNames.unshift dayNames[dayNames.length - 1]
    now = new Date()
    closed = now.getHours() * 60 + now.getMinutes() >= closeTime
    $scope.datepickerOptions =
        minDate: dateDaysLater(if closed then 1 else 0)
        maxDate: dateDaysLater(maxOrderIntervalDays)

    $scope.vkLoggedIn = false
    $scope.vkButtonText = 'Войти через VK'

    $scope.$watch 'vkLoggedIn', (logged) ->
        checkLoginStatus (session) ->
                $scope.vkButtonText = 'Загрузка...'
                getSessionUser session, (user) ->
                    text =
                        if user then "#{user.first_name} #{user.last_name} (выход)"
                        else 'Ошибка'
                    $scope.$apply ($scope) ->
                        $scope.vkButtonText = text

                    postRequest
                        data: action: 'getUserPhone'
                        success: (response) ->
                            console.log response
                            if response.phone
                                $scope.order.phone = response.phone

                    postRequest
                        data: action: 'getUserRecord'
                        success: (response) ->
                            console.log response
                            setRecord response

                    postRequest
                        data:
                            action: 'addUser'
                            user:
                                firstName: user.first_name
                                lastName: user.last_name
                                domain: user.domain
                        success: (response) ->
                            console.log 'addUser', response
            , ->
                $scope.record = null
                $scope.vkButtonText = 'Войти через VK'
