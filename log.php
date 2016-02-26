<?php
require('../smarty/libs/Smarty.class.php');
require_once('../keys.php');

$smarty = new Smarty();

$smarty->setTemplateDir('templates');
$smarty->setCompileDir('smarty/compile');
$smarty->setCacheDir('smarty/cache');
$smarty->setConfigDir('smarty/config');

session_start();

$isAdmin = false;
$isWrongPassword = false;

if (isset($_SESSION['isAdmin'])) {
    $isAdmin = true;
} else {
    if (isset($_POST['password'])) {
        if ($_POST['password'] == ADMIN_PASSWORD) {
            $_SESSION['isAdmin'] = true;
            header('Location: /log.php');
        } else {
            $isWrongPassword = true;
        }
    }
}

$smarty->assign('isWrongPassword', $isWrongPassword);
$smarty->assign('isAdmin', $isAdmin);
$smarty->display('log.tpl');
