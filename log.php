<?php
require('../smarty/libs/Smarty.class.php');
include('debug.php');

$smarty = new Smarty();

$smarty->setTemplateDir('templates');
$smarty->setCompileDir('smarty/compile');
$smarty->setCacheDir('smarty/cache');
$smarty->setConfigDir('smarty/config');

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
