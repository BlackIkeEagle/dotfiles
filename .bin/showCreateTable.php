#!/usr/bin/env php
<?php

function removeFromArgv(&$argv, $key, $value) {
	$keys = array_keys($argv, $key);
	$keys = array_merge($keys, array_keys($argv, $value));
	$keys = array_merge($keys, array_keys($argv, $key.$value));
	if (is_array($keys) && count($keys) > 0) {
		foreach ($keys as $rmKey) {
			unset($argv[$rmKey]);
		}
	}
}

# remove first element of the array, is the filename
array_shift($argv);

/**
 * Default settings for mysql
 */
$host = 'localhost';
$user = 'root';
$pass = '';
$port = '3306';
$db = '';
$table = array();

$options = getopt('h:u:p:P:');

foreach($options as $short => $value) {
	switch($short) {
	case 'h':
		$host = $value;
		removeFromArgv($argv, '-'.$short, $value);
		break;
	case 'u':
		$user = $value;
		removeFromArgv($argv, '-'.$short, $value);
		break;
	case 'p':
		$pass = $value;
		removeFromArgv($argv, '-'.$short, $value);
		break;
	case 'P':
		$port = $value;
		removeFromArgv($argv, '-'.$short, $value);
		break;
	default:
		break;
	}
}

$x = 0;
while (count($argv) > 0) {
	if ($x == 0) { // db
		$db = array_shift($argv);
	} elseif ($x >= 1) { // table
		$table[] = array_shift($argv);
	}
	$x++;
}

if (empty($db)) {
	echo 'You have to pass the db' . PHP_EOL;
	exit(1);
}

if (empty($table)) {
	echo 'You have to pass the table' . PHP_EOL;
	exit(1);
}

$mysql = new mysqli($host, $user, $pass, $db, $port);

foreach ($table as $tbl) {
	$createTable = $mysql->query("SHOW CREATE TABLE `$tbl`")->fetch_assoc()["Create Table"] . PHP_EOL;
	$lines = explode("\n", $createTable);
	$x = 0;
	foreach ($lines as $line) {
		if ($x == 0) {
			echo "\t\t" . '$sql = "' . $line . '"';
		} else {
			if ($line !== "") {
				$line = preg_replace('/AUTO_INCREMENT=[0-9]* /', '', $line);
				echo PHP_EOL . "\t\t" . "\t" . '. "' . $line . '"';
			}
		}
		$x++;
	}
	echo ';' . PHP_EOL;
	echo "\t\t" . '$this->_db->query($sql);' . PHP_EOL . PHP_EOL;
}
