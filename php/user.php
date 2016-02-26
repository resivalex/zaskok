<?php

require_once('debug.php');
require_once('check.php');
require_once('database.php');
    
date_default_timezone_set('Europe/Samara');

$repository = new Repository();

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

echo json_encode(['data' => executeRequest($request)]);

function executeRequest($param) {
    global $openApiMember;

    if (isset($param->action)) {
        $action = $param->action;

        $publicActions = [
            'getPlaceMapByDate' => ['date']
        ];
        $actions = [
            'getUserRecord' => [],
            'getUserPhone' => [],
            'addRecord' => ['record'],
            'removeRecord' => ['token'],
            'addUser' => ['user']
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

function notifyByEmail($subject, $message) {
    $headers  = MAIL_HEADERS."\r\n";
    $headers .= 'MIME-Version: 1.0'."\r\n";
    $headers .= 'Content-type: text/html; charset=UTF-8'."\r\n";
    $style = 'font-family:monospace;';
    mail(NOTIFY_MAIL, $subject, '<pre style="'.$style.'">'.$message.'</pre>', $headers);
}

function getPlaceMapByDate($date) {
    return repository()->getPlaceMapByDate($date);
}

function getUserRecord() {
    global $openApiMember;
    return repository()->getActualRecordByVkId($openApiMember['id']);
}

function getUserPhone() {
    global $openApiMember;
    $phone = repository()->getUserPhoneByVkId($openApiMember['id']);
    return ['phone' => $phone];
}

function getRecordSummary($user, $record) {
    $username = $user['first_name'].' '.$user['last_name'];
    $phone = $record['phone'];
    $months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля',
            'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    $datetime = $record['datetime'];
    $date = date('d', $datetime).' '.$months[intval(date('m', $datetime)) - 1];
    $time = date('H:i', $datetime);
    $guests = $record['guests'];
    if ($guests == 10) {
        $guests = 'Аренда';
    } else {
        if ($guests == 2 || $guests == 3 || $guests == 4) {
            $guests .= ' человека';
        } else {
            $guests .= ' человек';
        }
    }
    $duration = $record['duration'];
    if ($duration == 120) {
        $duration = '2 часа';
    } else {
        $duration .= ' минут';
    }
    $domain = $user['domain'];
    return <<<SUMMARY
Пользователь           $username
Телефон                $phone

Дата                   $date
Время                  $time

Количество человек     $guests
Длительность           $duration

http://vk.com/$domain
SUMMARY;
}

function notifyAction($action, $user, $record) {
    notifyByEmail($action.' | '.$user['first_name'].' '.$user['last_name'],
        getRecordSummary($user, toAssoc($record)));
}

function addRecord($record) {
    global $openApiMember;
    $repository = repository();

    if ($record->datetime - 60 < time()) {
        $result = 'Время уже прошло';
    } else {
        $result = $repository->addUserRecord(toAssoc($record), $openApiMember['id']);
    }
    if (gettype($result) != 'string') {
        $user = $repository->getUserByVkId($openApiMember['id']);
        notifyAction('Добавлена заявка', $user, $record);
    }
    return $result;
}

function removeRecord($token) {
    global $openApiMember;
    $repository = repository();

    $record = $repository->getRecordByToken($token);
    $result = $repository->removeRecordByToken($token);
    if ($record) {
        $user = $repository->getUserByVkId($openApiMember['id']);
        notifyAction('Удалена заявка', $user, $record);
    }

    return $result;
}

function addUser($user) {
    global $openApiMember;
    return repository()->addUser(toAssoc($user), $openApiMember['id']);
}