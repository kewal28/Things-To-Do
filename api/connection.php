<?php
error_reporting(0);
header('Access-Control-Allow-Methods: GET, POST, PUT, OPTIONS');
header('Access-Control-Allow-Headers: Origin, Content-Type');
try {
	mysql_connect("localhost", "dlc77588_dlcl", "dlcl!@#123");
	mysql_select_db("dlc77588_thing_to_do");
} catch (Exception $e) {
	print_r($e->getMessage());
	die;
}