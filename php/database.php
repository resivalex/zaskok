<?php

require_once('../../keys.php');
require_once('./lib/safemysql.class.php');

const MAX_GUESTS = 10;

class Repository {
	var $sql;

	function __construct() {
		$this->sql = new SafeMysql([
			'user' => DB_USER,
			'pass' => DB_PASSWORD,
			'db' => DB_NAME,
			'charset' => 'utf8']);
	}

	private function joinDateTime($date, $time) {
		return strtotime($date.' '.$time);
	}

	function getRecordByToken($token) {
		$record = $this->sql->getRow('SELECT * FROM records WHERE token=?s', $token);
		if ($record) {
			$record['datetime'] = $this->joinDateTime($record['date'], $record['time']);
			unset($record['date']);
			unset($record['time']);
		}

		return $record;
	}

	private function getActualRecordByToken($token) {
		if ($record = $this->getRecordByToken($token)) {
			$datetime = $record['datetime'];
			$datetime += $record['duration'] * 60;
			if ($datetime > time()) {
				return $record;
			}
		}

		return false;
	}

	function getActualRecordByVkId($vkId) {
		$user = $this->getUserByVkId($vkId);
		return $this->getActualRecordByToken($user['last_record_token']);
	}

	function getUserPhoneByVkId($vkId) {
		if ($user = $this->getUserByVkId($vkId)) {
			return $user['phone'];
		}

		return false;
	}

	private function replaceKey(&$arr, $from, $to) {
		$val = $arr[$from];
		unset($arr[$from]);
		$arr[$to] = $val;
	}

	function addUser($user, $vkId) {
		$info = $user;
		$this->replaceKey($info, 'firstName', 'first_name');
		$this->replaceKey($info, 'lastName', 'last_name');
		$data = $this->sql->filterArray($info, ['first_name', 'last_name', 'domain']);
		$data['vk_id'] = $vkId;

		return $this->sql->query('INSERT IGNORE INTO users SET ?u', $data);
	}

	function getUserByVkId($vkId) {
		return $this->sql->getRow('SELECT * FROM users WHERE vk_id=?s', $vkId);
	}

	private function getRandomToken() {
		$token = '';
		for ($i = 0; $i < 8; $i++) {
			$token .= 'abcdefghigklmnopqrstuvwxyzABCDEFGHIGKLMNOPQRSTUVWXYZ'[rand(0, 26 * 2 - 1)];
		}
		return $token;
	}

	private function separateDateTime($arr) {
		$datetime = $arr['datetime'];
		unset($arr['datetime']);
		$arr['date'] = date('Y-m-d', $datetime);
		$arr['time'] = date('H:i:s', $datetime);

		return $arr;
	}

	private function areRecordsOverflow($posixDate) {
		$place = $this->getPlaceMapByDate($posixDate);
		foreach ($place as $cell) {
			if ($cell > MAX_GUESTS) {
				return true;
			}
		}

		return false;
	}

	private function addRecord($record) {
		$data = $this->separateDateTime($record);

		if (strtotime($data['time']) < strtotime('10:00:00')) {
			return "Ещё не открыто";
		}
		if (strtotime($data['time']) + $record['duration'] * 60 > strtotime('22:00:00')) {
			return "Уже закрыто";
		}

		$token = $this->getRandomToken();
		$data['token'] = $token;
		$this->sql->query('INSERT INTO records SET ?u', $data);

		if ($this->areRecordsOverflow($record['datetime'])) {
			$this->removeRecordByToken($token);
			return "Выбранное место уже занято.";	
		}

		return $record + ['token' => $token];
	}

	function addUserRecord($record, $vkId) {
		if (!($user = $this->getUserByVkId($vkId))) {
			return "Не найден пользователь. Вы авторизованы?";
		}
		$token = $user['last_record_token'];

		if ($this->getActualRecordByToken($token)) {
			return "Вы уже оставили заявку. Обновите страницу.";
		}
		$userId = $user['id'];
		$phone = $record['phone'];

		$data = $this->sql->filterArray($record, ['guests', 'duration', 'phone', 'datetime']);
		$data['user_id'] = $userId;

		$result = $this->addRecord($data);
		if (gettype($result) == 'string') {
			return $result;
		}

		$this->sql->query('UPDATE users SET ?u WHERE id=?i',
			['last_record_token' => $result['token'], 'phone' => $phone], $userId);

		return $result;
	}

	function addAdminRecord($record) {
		$data = $this->sql->filterArray($record,
				['guests', 'duration', 'phone', 'datetime', 'userName']);
		$this->replaceKey($data, 'userName', 'user_name');

		return $this->addRecord($data);
	}

	function getRecords($condition = 'TRUE') {
		return $this->sql->getAll(
<<<SQL
			SELECT date, time, guests, duration,
				first_name AS firstName,
				last_name AS lastName,
				domain,
				records.phone AS phone,
				token, user_name AS userName
			FROM records
			LEFT JOIN users ON user_id = users.id
			WHERE ?p
			ORDER BY records.id
SQL
		, $condition);
	}

	function getRecordsByDate($posixDate) {
		$condition = $this->sql->parse("date = ?s", date('Y-m-d', $posixDate));
		return $this->getRecords($condition);
	}

	function getPlaceMapByDate($posixDate) {
		$records = $this->getRecordsByDate($posixDate);

		$place = [];
		for ($i = 0; $i < 72; $i++) {
			$place[] = 0;
		}
		foreach ($records as $record) {
			$index = (strtotime($record['time']) - strtotime('10:00:00')) / 60 / 10;
			$steps = $record['duration'] / 10;
			for ($i = $index; $i < $index + $steps && $i < 72; $i++) {
				$place[$i] += $record['guests'];
			}
		}

		return $place;
	}

	function removeRecordByToken($token) {
		return $this->sql->query('DELETE FROM records WHERE token=?s' , $token);
	}

	function getUsers() {
		return $this->sql->getAll(
<<<SQL
			SELECT reg_date AS regDate, first_name AS firstName, last_name AS lastName, domain, phone
			FROM users
			ORDER BY reg_date DESC
SQL
		);
	}
};

function repository() {
	return new Repository();
}

function toAssoc($obj) {
	return json_decode(json_encode($obj), true);
}
