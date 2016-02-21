<?php

require_once('debug.php');
require_once('check.php');
require_once('database.php');

if ($member = getAuthOpenApiMember()) {
	$info = [];
	foreach ($_POST as $key => $value) {
		$info[$key] = $value;
	}
	$vk_id = $info['uid'];
	unset($info['uid']);
	$info['vk_id'] = $vk_id;

	$response = $db->addUserInfo($info);
	if (isset($response['date'])) {
		$date = $response['date'];
		$time = $response['time'];
		unset($response['date']);
		unset($response['time']);
		$response['datetime'] = strtotime($date.' '.$time);
	}
} else {
	$response = "Авторизация не удалась";
}

echo json_encode($response);
