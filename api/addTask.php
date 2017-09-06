<?php

require 'connection.php';

if (isset($_POST["taskTitle"]) && !empty($_POST["taskTitle"])) {
	$userId = mysql_real_escape_string($_POST['userId']);
	$taskTitle = mysql_real_escape_string($_POST['taskTitle']);
	$taskDescription = mysql_real_escape_string($_POST['taskDescription']);
	$createdDate = date("Y-m-d H:i:s");
	$updatedDate = date("Y-m-d H:i:s");
    $row = mysql_query("INSERT INTO `tasks` (`userId`, `taskTitle`, `taskDescription`, `createdDate`, `updatedDate`, `status`) VALUES ('$userId', '$taskTitle', '$taskDescription', '$createdDate', '$updatedDate', 'Pending')");
    if ($row) {
        print_r(json_encode(array('status' => "true", 'error' => '')));
    } else {
        print_r(json_encode(array('status' => "false", 'error' => 'Task add Fail.')));
    }
} else {
	print_r(json_encode(array('status' => "false", 'error' => 'Request is not Proper.')));
}