<?php

require_once('check.php');
require_once('database.php');

$db->remove_record($_POST['token']);

echo json_encode('');
