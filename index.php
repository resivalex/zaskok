<?php
require('../smarty/libs/Smarty.class.php');

$smarty = new Smarty();

$smarty->setTemplateDir('templates');
$smarty->setCompileDir('smarty/compile');
$smarty->setCacheDir('smarty/cache');
$smarty->setConfigDir('smarty/config');


$sections = [];

$sections['about'] = array(
    'title' => 'О нас',
    'id' => 'about',
    'file' => 'about.tpl'
);

$sections['gallery'] = array(
    'title' => 'Галерея',
    'id' => 'gallery',
    'file' => 'gallery.tpl'
);

$sections['prices'] = array(
    'title' => 'Цены',
    'id' => 'prices',
    'file' => 'prices.tpl'
);

$sections['order'] = array(
    'title' => 'Запись',
    'id' => 'order',
    'file' => 'order.tpl'
);

$sections['contacts'] = array(
    'title' => 'Контакты',
    'id' => 'contacts',
    'file' => 'contacts.tpl'
);

$partners = [];

$files = scandir('img/slider');
$thumbs = [];
$slides = [];
foreach ($files as $file) {
    if (!is_dir('img/slider/'.$file)) {
        $thumbs[] = 'img/slider/thumbnails/'.$file;
        $slides[] = 'img/slider/'.$file;
    }
}

$facts = [
    'we_are' => [
        'title' => 'Зал',
        'image_class' => 'ball-image',
        'lines' => [
            'Мы находимся на третьем этаже ТРЦ ОМЕГА',
            'В нашем зале 8 батутов',
            'Зал открыт с 10 до 22 часов',
            'Наши тренеры помогут вам отработать акробатические трюки'
        ]
    ],
    'wealth' => [
        'title' => 'О пользе батута',
        'image_class' => 'leaf-image',
        'lines' => [
            'Повышает выносливость',
            'Тренирует все группы мышц',
            'Развивает вестибулярный аппарат',
            'Ускоряет процесс обмена веществ в организме',
            'Улучшает эмоциональное состояние',
            'Превосходная подготовка к другим экстремальным видам спорта'
        ]
    ],
    'children' => [
        'title' => 'Дети',
        'image_class' => 'children-image',
        'lines' => [
            'Батут - это особенно большая радость для детей',
            'Способствует правильному развитию опорно-двигательного аппарата',
            'Улучшаются двигательные навыки и координация',
            'Воспитывает любовь к спорту'           
        ]
    ],
    'celebration' => [
        'title' => 'Праздники',
        'image_class' => 'gift-image',
        'lines' => [
            'Хорошее место, чтобы прийти на праздники с друзьями',
            'Можно арендовать зал полностью'    
        ]
    ]
];

// print_r($facts);

$smarty->assign('title', 'ZAскок - Батутный центр');
$smarty->assign('facts', $facts);
$smarty->assign('slides', $slides);
$smarty->assign('thumbs', $thumbs);
$smarty->assign('sections', $sections);
$smarty->assign('partners', $partners);
$smarty->display('index.tpl');

?>