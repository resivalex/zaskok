<?php

require_once('debug.php');
require_once('database.php');

$repository = new Repository();

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

echo json_encode(executeRequest($request));

function executeRequest($param) {
	session_start();
	if (!isset($_SESSION['isAdmin'])) {
		return 'Not admin!';
	}

	if (isset($param->action)) {
		$action = $param->action;

		$actions = [
			'getAllRecords' => [],
			'recordsByDate' => ['date'],
			'getDateStat' => ['dateFrom', 'dateTo'],
			'removeRecordByToken' => ['token']
		];
		if (isset($actions[$action])) {
			$argNames = $actions[$action];
			$args = [];
			foreach ($argNames as $argName) {
				if (isset($param->$argName)) {
					$args[] = $param->$argName;
				} else {
					return "$argName is absent for $report";
				}
			}
			return $action(...$args);
		}
		return 'unknown action';
	} else {
		return 'action is absent';
	}
}

function getAllRecords() {
	return repository()->getAllRecords();
}

function recordsByDate($date) {
	return repository()->recordsByDate(date('Y-m-d', $date));
}

function getDateStat($dateFrom, $dateTo) {
	return Array();
}

function removeRecordByToken($token) {
	return repository()->removeRecordByToken($token);
}

function addAdminRecord($record) {
	return repository()->addAdminRecord($record);
}