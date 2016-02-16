<?php

include('debug.php');
include('check.php');
include('database.php');

add_user_info($sql, $_POST);

echo auth_open_api_member() ? 'true' : 'false';

// echo '<pre>';
// var_dump($_POST);
// var_dump($cookie_data);
// echo '</pre>';