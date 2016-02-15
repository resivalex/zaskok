<?php
require('../smarty/libs/Smarty.class.php');

$smarty = new Smarty();

$smarty->setTemplateDir('templates');
$smarty->setCompileDir('smarty/compile');
$smarty->setCacheDir('smarty/cache');
$smarty->setConfigDir('smarty/config');

ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
ini_set('error_reporting', E_ALL);
date_default_timezone_set('Europe/Moscow');

session_start();

$is_admin = false;
$is_wrong_password = false;

if (isset($_SESSION['is_admin'])) {
	$is_admin = true;
} else {
	if (isset($_POST['password'])) {
		if ($_POST['password'] == 'patented') {
	    	$_SESSION['is_admin'] = true;
	    	header('Location: /log.php');
	    } else {
	    	$is_wrong_password = true;
	    }
	}
}

$smarty->assign('is_wrong_password', $is_wrong_password);
$smarty->assign('is_admin', $is_admin);
$smarty->display('admin.tpl');
