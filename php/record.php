<?php

require_once('check.php');
require_once('database.php');

const MAX_GUESTS = 10;

if ($member = getAuthOpenApiMember()) {
	$token = '';
	for ($i = 0; $i < 8; $i++) {
		$token .= 'abcdefghigklmnopqrstuvwxyzABCDEFGHIGKLMNOPQRSTUVWXYZ'[rand(0, 26 * 2 - 1)];
	}

	$record = [];
	foreach ($_POST as $key => $value) {
		$record[$key] = $value;
	}
	$record['token'] = $token;
	$datetime = $record['datetime'];
	$date = date('Y-m-d', $datetime);
	$time = date('H:i:s', $datetime);
	unset($record['datetime']);
	$record['date'] = $date;
	$record['time'] = $time;

	$record = $db->add_record($record, $member['id']);
	$place = $db->place_map_by_date($date);
	$overflow = false;
	foreach ($place as $cell) {
		if ($cell > MAX_GUESTS) {
			$overflow = true;
		}
	}
	if ($overflow) {
		$db->remove_record($token);
		$record = "Выбранное место занято";
	}

	if (gettype($record) == 'array') {
		$date = $record['date'];
		$time = $record['time'];
		unset($record['date']);
		unset($record['time']);
		$record['datetime'] = strtotime($date.' '.$time);
	}

	$response = $record;
} else {
	$response = 'Вы авторизованы?';
}

echo json_encode($response);
