<?php

session_start();
if (!isset($_SESSION['is_admin'])) {
	echo 'Not admin!';
	exit(0);
}

require_once('debug.php');
require_once('database.php');

function db() {
	return $GLOBALS['db'];
}

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

echo json_encode(execute($request));

function execute($param) {
	if (isset($param->report)) {
		$report = $param->report;
		if ($report == 'all_records') {
			return all_records();
		}
		if ($report == 'records_by_date') {
			if (isset($param->date)) {
				return records_by_date($param->date);
			} else {
				return 'date is absent';
			}
		}
		if ($report == 'day_stat') {
			if (isset($param->date_from) && isset($param->date_to)) {
				return day_stat($param->date_from, $param->date_to);
			} else {
				return 'date_from or date_to is absent';
			}
		}
		return 'unknown report';
	}
	if (isset($param->action)) {
		$action = $param->action;
		if ($action == 'remove_record') {
			if (isset($param->token)) {
				return remove_record($param->token);
			} else {
				return 'token is absent';
			}
		}
	}
	return 'unknow request';
}

function all_records() {
	return db()->all_records();
}

function records_by_date($date) {
	return db()->records_by_date(date('Y-m-d', $date));
}

function day_stat($date_from, $date_to) {
	return Array();
}

function remove_record($token) {
	db()->remove_record($token);
	return true;
}