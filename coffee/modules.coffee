msInDay = 1000 * 3600 * 24
apiId = 5297183

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

# месяц в родительном падеже
monthNameOf = (index) ->
    monthName = monthNames[index]
    switch monthName
        when "Март", "Август" then monthName + 'а'
        else monthName.substring(0, monthName.length - 1) + 'я'

checkLoginStatus = (onlineHandler, offlineHandler) ->
    VK.Auth.getLoginStatus (response) ->
        if response.session
            console.log response
            onlineHandler(response.session)
        else
            offlineHandler()

angular.module 'myFormats', []
.filter 'dateFormat', ->
    (input, aliases = false) ->
        if input
            dateStr = "#{input.getDate()} #{monthNameOf(input.getMonth())}"
            if aliases
                dateStr = 'Завтра' if input.getTime() - new Date().getTime() < msInDay
                dateStr = 'Сегодня' if input.getTime() - new Date().getTime() < 0
            dateStr
        else
            '?'

.filter 'timeFormat', ->
    (input) ->
        if input
            temp = parseInt(input)
            hour = Math.floor temp / 60
            minute = temp - 60 * hour
            "#{hour}:" + if minute == 0 then "00" else "#{minute}"
        else
            '?'

.filter 'durationFormat', ->
    (input) ->
        if input
            if input <= 60
                "#{input} минут"
            else
                "#{input / 60} часа"
        else
            '?'

.filter 'guestsRentFormat', ->
    (input, addHuman) ->
        num = parseInt(input)
        if num == 10
            'Аренда'
        else
            tail = ""
            if addHuman
                tail = " человек"
                if [2, 3, 4].indexOf(num) != -1
                    tail += "а"
            num + tail

angular.module 'myDirectives', []
.directive 'myButtonfield', ($parse) ->
    (scope, element, attrs, controller) ->
        ngModel = $parse(attrs.ngModel)
        $ ->
            element.find('[type=radio]').each ->
                $(@).button()

            scope.$watch attrs.myButtonfield, ->
                element.find('[type=radio]').each (index) ->
                    if not eval("scope.#{attrs.myButtonfield}")[index]
                        if $(@).is(':checked')
                            console.log 'ok'
                            $(@).attr 'checked', false
                            eval("scope.#{attrs.ngModel} = null")
                        $(@).attr 'checked', false
                        $(@).button 'disable'
                    else
                        $(@).button 'enable'
                element.find('[type=radio]').each (index) ->
                    $(@).button 'refresh'

            element.on 'change', '[type=radio]', ->
                element.find('[type=radio]').each (index) ->
                    $(@).button 'refresh'

.directive 'myButtonset', ($parse) ->
    (scope, element, attrs, controller) ->
        ngModel = $parse(attrs.ngModel)
        $ ->
            element.buttonset()
            element.on 'change', '[type=radio]', ->
                element.buttonset 'refresh'

.directive 'myButton', ($parse) ->
    (scope, element) ->
        $ ->
            element.button()

.directive 'myVk', ($parse) ->
    (scope, element, attrs) ->
        ngModel = $parse(attrs.ngModel)
        $ ->
            VK.init apiId: apiId

            element.on 'click', ->
                checkLoginStatus ->
                        VK.Auth.logout()
                    , ->
                        VK.Auth.login()

            VK.Observer.subscribe 'auth.logout', ->
                scope.$apply (scope) ->
                    ngModel.assign scope, false

            VK.Observer.subscribe 'auth.login', ->
                scope.$apply (scope) ->
                    ngModel.assign scope, true

.directive 'myDatepicker', ($parse) ->
    (scope, element, attrs) ->
        ngModel = $parse(attrs.ngModel)
        $ ->
            dayNames = russianDayNames
            dayNames.unshift dayNames[dayNames.length - 1]
            options =
                monthNames: monthNames
                dayNamesMin: dayNames
                firstDay: 1
                onSelect: (date) ->
                    scope.$apply (scope) ->
                        ngModel.assign scope, new Date(date)

            externalOptions = eval("scope.#{attrs.myDatepicker}")
            $.extend(options, externalOptions)
            element.datepicker options
            scope.$apply ($scope) ->
                ngModel.assign scope, element.datepicker 'getDate'

timeZoneDelta = -240 - new Date().getTimezoneOffset()

window.availablePlaces = (place, date, guests, duration, ignoreTime = false) ->
    openTime = 10 * 60 # 10:00
    closeTime = 22 * 60 # 22:00
    timeDelta = 10 # minutes
    maxGuests = 10

    isToday = date.getDate() == (new Date()).getDate() && date.getMonth() == (new Date()).getMonth()
    samaraMinutesNow = (new Date()).getHours() * 60 + (new Date()).getMinutes() - timeZoneDelta

    for index in [0...72]
        enabled = on 
        time = openTime + index * timeDelta
        if time + duration > closeTime
            enabled = off

        if not ignoreTime
            if isToday && time < samaraMinutesNow
                enabled = off

        countInDelta = duration / timeDelta
        for i in [index...Math.min(index + countInDelta, place.length)]
            if place[i] + guests > maxGuests
                enabled = off
        enabled

window.toSamaraDate = (date) ->
    if date instanceof Date
        Math.round date.getTime() / 1000 + timeZoneDelta * 60
    else
        0

window.fromSamaraDate = (posixTime) ->
    if typeof(posixTime) == 'number'
        return new Date((posixTime - timeZoneDelta * 60) * 1000)