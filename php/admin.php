<?php

require_once('debug.php');
require_once('database.php');

$repository = new Repository();

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

echo json_encode(['data' => executeRequest($request)]);

function executeRequest($param) {
	session_start();
	if (!isset($_SESSION['isAdmin'])) {
		return 'Not admin!';
	}

	if (isset($param->action)) {
		$action = $param->action;

		$actions = [
			'getAllRecords' => [],
			'getRecordsByDate' => ['date'],
			'recordsByDate' => ['date'],
			'getDateStat' => ['dateFrom', 'dateTo'],
			'addRecord' => ['record'],
			'removeRecord' => ['token'],
			'getUsers' => []
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
	return repository()->getRecords();
}

function recordsByDate($date) {
	return repository()->recordsByDate(date('Y-m-d', $date));
}

function getDateStat($dateFrom, $dateTo) {
	return Array();
}

function addRecord($record) {
	return repository()->addAdminRecord(toAssoc($record));
}

function removeRecord($token) {
	return repository()->removeRecordByToken($token);
}

function getRecordsByDate($date) {
	return repository()->getRecordsByDate($date);
}

function getUsers() {
	return repository()->getUsers();
}