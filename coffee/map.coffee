init = ->
    # Координаты зала
    zaskokGoords = [56.871612,53.227515]
    # Начальный масштаб
    initZoom = 15
    
    # Создание экземпляра карты и его привязка к контейнеру с
    # заданным id ("map").
    myMap = new ymaps.Map 'map',
            # При инициализации карты обязательно нужно указать
            # её центр и коэффициент масштабирования.
            center: zaskokGoords, # Зал
            zoom: initZoom
        , 
            searchControlProvider: 'yandex#search'

    # отключаем масштабирование колёсиком
    myMap.behaviors.disable 'scrollZoom'

    # Создаем геообъект с типом геометрии "Точка".
    zaskokGeoObject = new ymaps.GeoObject
        # Описание геометрии.
        geometry:
            type: 'Point',
            coordinates: zaskokGoords
        ,
        # Свойства.
        properties:
            # Контент метки.
            iconContent: 'Батутный центр ZAскок',
            hintContent: 'ул. 10 лет Октября, д.32, ТРЦ "Омега", 3-ий этаж'
    ,
        # Опции.
        # Иконка метки будет растягиваться под размер ее содержимого.
        preset: 'islands#blueStretchyIcon',

    myMap.geoObjects.add zaskokGeoObject

# Дождёмся загрузки API и готовности DOM.
ymaps.ready init
