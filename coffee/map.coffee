init = ->
    # Координаты зала
    airPlazaCoords = [57.810842, 28.360244]
    # Начальный масштаб
    initZoom = 17

    # Вспомогательные точки на карте
    hints = [
            title: 'Максимус'
            coords: [57.810049, 28.362032]
            minZoom: 15
        ,
            title: 'Летний сад'
            coords: [57.813808, 28.345585]
            minZoom: 13
        ,
            title: 'Площадь Ленина'
            coords: [57.819336, 28.332823]
            minZoom: 12
        ,
            title: 'Ж/д вокзал'
            coords: [57.804437, 28.361996]
            minZoom: 13
    ]
    
    # Создание экземпляра карты и его привязка к контейнеру с
    # заданным id ("map").
    myMap = new ymaps.Map 'map',
            # При инициализации карты обязательно нужно указать
            # её центр и коэффициент масштабирования.
            center: airPlazaCoords, # Зал
            zoom: initZoom
        , 
            searchControlProvider: 'yandex#search'

    # отключаем масштабирование колёсиком
    myMap.behaviors.disable 'scrollZoom'

    # Создаем геообъект с типом геометрии "Точка".
    airPlazaGeoObject = new ymaps.GeoObject
        # Описание геометрии.
        geometry:
            type: 'Point',
            coordinates: airPlazaCoords
        ,
        # Свойства.
        properties:
            # Контент метки.
            iconContent: 'Air Plaza',
            hintContent: 'Батутный парк'
    ,
        # Опции.
        # Иконка метки будет растягиваться под размер ее содержимого.
        preset: 'islands#blueStretchyIcon',

    hintGeoObjects = []

    for hint in hints
        hintGeoObjects.push new ymaps.GeoObject
            geometry:
                type: "Point"
                coordinates: hint.coords
            properties:
                iconContent: hint.title
        ,
            preset: 'islands#blackStretchyIcon'

    # Добавляем метки на карту
    for object in hintGeoObjects
        myMap.geoObjects.add object

    myMap.geoObjects.add airPlazaGeoObject

    # Скрытие дополнительных меток на карте с большим масштабом
    updateGeoObjectsVisibility = (zoom) ->
        for object, i in hintGeoObjects
            object.options.set 'visible', zoom >= hints[i].minZoom

    updateGeoObjectsVisibility initZoom

    myMap.events.add 'boundschange', (e) ->
        updateGeoObjectsVisibility e.get 'newZoom'

# Дождёмся загрузки API и готовности DOM.
ymaps.ready init
