<?php

include('debug.php');

$sql = new mysqli("p:localhost", "cy44684_db", "mint", "cy44684_db");
$sql->query("SET NAMES 'utf8'");

// $result = $sql->query("SELECT id, record FROM history;");

// $select_result = [];
// while ($field = $result->fetch_field()) {
// 	$select_result[$field->name] = array();
// }
// while ($row = $result->fetch_array(MYSQLI_ASSOC)) {
// 	foreach ($row as $field => $value) {
// 		echo $field.' '.$value.';';
// 	}
// }

function add_user_info($sql, $user) {
	$record = $sql->escape_string($user['first_name']);
	$sql->query("INSERT INTO history (record) VALUES ('$record');");
	$keys = ['uid', 'first_name', 'last_name', 'phone', 'domain'];
	foreach ($keys as $key) {
		$temp = $sql->escape_string($user[$key]);
		eval('$'.$key.' = $temp;');
	}
	$sql->query(<<<SQL
INSERT INTO users
(vk_id, first_name, last_name, domain)
VALUES ('$uid', '$first_name', '$last_name', '$domain');
SQL
	);
}