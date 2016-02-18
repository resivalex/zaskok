<?php

require_once('../keys.php');

class Database {
	var $sql;

	function __construct() {
		$this->sql = new mysqli("p:localhost", DB_USER, DB_PASSWORD, DB_NAME);
		$this->sql->query("SET NAMES 'utf8'");
	}

	private function query($str) {
		return $this->sql->query($str);
	}

	private function escape($str) {
		return $this->sql->escape_string($str);
	}

	private function fetch_assoc_array($sql_result) {
		if ($sql_result == false) {
			return Array();
		}
		$arr = [];
		while ($row = $sql_result->fetch_array(MYSQLI_ASSOC)) {
			$arr[] = $row;
		}

		return $arr;
	}

	private function record_by_token($token) {
		$result = $this->query(
<<<SQL
			SELECT date, time, guests, duration, phone, token
			FROM records
			WHERE token='$token'
SQL
		);

		$rec_arr = $this->fetch_assoc_array($result);
		if (isset($rec_arr[0])) {
			return $rec_arr[0];
		} else {
			return false;
		}
	}

	private function actual_record_by_token($token) {
		if ($record = $this->record_by_token($token)) {
			$datetime = strtotime($record['date'].' '.$record['time']);
			if ($datetime < time()) {
				return false;
			} else {
				return $record;
			}
		} else {
			return false;
		}
	}

	function add_user_info($info) {
		$keys = ['vk_id', 'first_name', 'last_name', 'domain'];
		foreach ($keys as $key) {
			$temp = $this->escape($info[$key]);
			eval('$'.$key.' = $temp;');
		}
		$this->query(
<<<SQL
			INSERT INTO users
			(vk_id, first_name, last_name, domain)
			VALUES ('$vk_id', '$first_name', '$last_name', '$domain');
SQL
		);
		$users_result = $this->query(
<<<SQL
			SELECT id, phone, last_record_token
			FROM users
			WHERE vk_id='$vk_id'
SQL
		);
		$user = $this->fetch_assoc_array($users_result)[0];
		$phone = $user['phone'];
		$token = $user['last_record_token'];

		$record = $this->actual_record_by_token($token);
		if (!$record) {
			$record = [];
			$record['phone'] = $phone;
		}

		return $record;
	}

	function add_record($record, $vk_id) {
		$esc_vk_id = $this->escape($vk_id);
		$result = $this->query(
<<<SQL
			SELECT id, last_record_token
			FROM users
			WHERE vk_id='$esc_vk_id'
SQL
		);
		$row = $result->fetch_array(MYSQLI_ASSOC);
		if (!$row) {
			return "Не найден пользователь. Вы авторизованы?";
		}
		$token = $row['last_record_token'];

		if ($this->actual_record_by_token($token)) {
			return "Вы уже оставили заявку. Обновите страницу.";
		}
		$user_id = $row['id'];
		$keys = ['guests', 'duration', 'phone', 'date', 'time', 'token'];
		foreach ($keys as $key) {
			$temp = $this->escape($record[$key]);
			eval('$'.$key.' = $temp;');
		}
		$this->query(
<<<SQL
			INSERT INTO records
			(user_id, date, time, guests, duration, phone, token)
			VALUES ($user_id, '$date', '$time', '$guests', '$duration', '$phone', '$token')
SQL
		);
		$esc_phone = $this->escape($phone);
		$this->query(
<<<SQL
			UPDATE users
			SET last_record_token='$token', phone='$esc_phone'
			WHERE id=$user_id
SQL
		);
		return $record;
	}

	function records_by_date($date) {
		$esc_date = $this->escape($date);
		$result = $this->query(
<<<SQL
			SELECT guests, time, duration
			FROM records
			WHERE date='$esc_date'
SQL
		);

		return $this->fetch_assoc_array($result);
	}

	function place_map_by_date($date) {
		$records = $this->records_by_date($date);

		for ($i = 0; $i < 72; $i++) {
			$place[] = 0;
		}
		foreach ($records as $record) {
			$index = (strtotime($record['time']) - strtotime('10:00:00')) / 60 / 10;
			$steps = $record['duration'] / 10;
			for ($i = $index; $i < $index + $steps; $i++) {
				$place[$i] += $record['guests'];
			}
		}

		return $place;
	}

	function remove_record($token) {
		$esc_token = $this->escape($token);
		$this->query(
<<<SQL
			DELETE FROM records
			WHERE token='$esc_token'
SQL
		);
	}
};

$db = new Database();
