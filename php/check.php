<?php

require_once('../../keys.php');

function getAuthOpenApiMember() {
	$session = [];
	$member = false;
	$validKeys = ['expire', 'mid', 'secret', 'sid', 'sig'];
	$cookieName = 'vk_app_'.APP_ID;
	$appCookie = isset($_COOKIE[$cookieName]) ? $_COOKIE[$cookieName] : false;
	if ($appCookie) {
		$sessionData = explode ('&', $appCookie, 10);
		foreach ($sessionData as $pair) {
			list($key, $value) = explode('=', $pair, 2);
			if (empty($key) || empty($value) || !in_array($key, $validKeys)) {
				continue;
			}
			$session[$key] = $value;
		}
		foreach ($validKeys as $key) {
			if (!isset($session[$key])) return $member;
		}
		ksort($session);

		$sign = '';
		foreach ($session as $key => $value) {
			if ($key != 'sig') {
				$sign .= ($key.'='.$value);
			}
		}
		$sign .= APP_SHARED_SECRET;
		$sign = md5($sign);
		if ($session['sig'] == $sign && $session['expire'] > time()) {
			$member = array(
				'id' => intval($session['mid']),
				'secret' => $session['secret'],
				'sid' => $session['sid']
			);
		}
	}
	return $member;
}
