<?php

require_once('database.php');

$place = [];

$date = date('Y-m-d', $_POST['date']);

echo json_encode($db->place_map_by_date($date));