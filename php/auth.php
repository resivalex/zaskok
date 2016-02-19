<?php

require_once('check.php');
require_once('database.php');

if ($member = auth_open_api_member()) {
	$info = [];
	foreach ($_POST as $key => $value) {
		$info[$key] = $value;
	}
	$vk_id = $info['uid'];
	unset($info['uid']);
	$info['vk_id'] = $vk_id;

	$response = $db->add_user_info($info);
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
