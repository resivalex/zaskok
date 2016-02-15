<?php

$sql = new mysqli("p:localhost", "root", "mint", "db");
$sql->query("SET NAMES 'utf8'");

$result = $sql->query("SELECT user FROM mysql.user;");

$select_result = [];
while ($field = $result->fetch_field()) {
	$select_result[$field->name] = array();
}
while ($row = $result->fetch_array(MYSQLI_ASSOC)) {
	foreach ($row as $field => $value) {
		echo $field.' '.$value.';';
	}
}
