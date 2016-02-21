<?php

require_once('debug.php');
require_once('check.php');
require_once('database.php');

$repository = new Repository();

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

echo json_encode(executeRequest($request));

function executeRequest($param) {
	global $openApiMember;

	if (isset($param->action)) {
		$action = $param->action;

		$publicActions = [
			'getPlaceMapByDate' => ['date']
		];
		$actions = [
			'getUserRecord' => [],
			'getUserPhone' => []
		];
		$actions += $publicActions;

		if (!($openApiMember = getAuthOpenApiMember()) && !isset($publicActions[$action])) {
			return 'Авторизация не подтверждена';
		}

		if (isset($actions[$action])) {
			$argNames = $actions[$action];
			$args = [];
			foreach ($argNames as $argName) {
				if (isset($param->$argName)) {
					$args[] = $param->$argName;
				} else {
					return "$argName is absent for $action";
				}
			}
			return $action(...$args);
		}
		return 'unknown action';
	} else {
		return 'action is absent';
	}
}

function getPlaceMapByDate($date) {
	return repository()->getPlaceMapByDate(date('YY-mm-dd', $date));
}

function getUserRecord() {
	return repository()->getRecordByVkId($openApiMember['id']);
}

function getUserPhone() {
	return repository()->getUserPhoneByVkId($openApiMember['id']);
}

function removeRecordByToken($token) {
	return repository()->removeRecordByToken($token);
}
