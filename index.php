<?php
require('../smarty/libs/Smarty.class.php');

$smarty = new Smarty();

$smarty->setTemplateDir('templates');
$smarty->setCompileDir('smarty/compile');
$smarty->setCacheDir('smarty/cache');
$smarty->setConfigDir('smarty/config');

$sections = [];

$sections['summary'] = array(
	'title' => 'Наверх',
	'id' => 'summary',
	'file' => 'summary.tpl'
);

$sections['programs'] = array(
	'title' => 'Наши программы',
	'id' => 'programs',
	'file' => 'programs.tpl'
);

$sections['prices'] = array(
	'title' => 'Цены',
	'id' => 'prices',
	'file' => 'prices.tpl'
);

$sections['about'] = array(
	'title' => 'О нас',
	'id' => 'about',
	'file' => 'about.tpl'
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

$partners['pwp'] = array(
	'url' => 'http://pwp.club/',
	'img' => 'img/partners/pwp.png',
	'title' => 'Вэй Парк'
);

$partners['rabbit'] = array(
	'url' => 'http://www.wrmedia.ru/',
	'img' => 'img/partners/rabbit.png',
	'title' => 'Дизайн&nbsp;студия'
);

$partners['taboo'] = array(
	'url' => 'https://vk.com/taboopskov',
	'img' => 'img/partners/taboo.png',
	'title' => 'Кальянная'
);

$partners['spectr'] = array(
	'url' => 'http://www.gpspectr.ru/',
	'img' => 'img/partners/spectr.png',
	'title' => 'ООО"Спектр"'
);

$smarty->assign('sections', $sections);
$smarty->assign('partners', $partners);
$smarty->display('index.tpl');

?>