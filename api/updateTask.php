<?php

require 'connection.php';

if (isset($_POST["taskId"]) && !empty($_POST["taskId"])) {
	$taskId = mysql_real_escape_string($_POST['taskId']);
	$taskTitle = mysql_real_escape_string($_POST['taskTitle']);
	$taskDescription = mysql_real_escape_string($_POST['taskDescription']);
	$updatedDate = date("Y-m-d H:i:s");
    $row = mysql_query("UPDATE `tasks` SET taskTitle='$taskTitle', taskDescription='$taskDescription', updatedDate='$updatedDate' WHERE id='$taskId'");
    if ($row) {
        print_r(json_encode(array('status' => "true", 'error' => '')));
    } else {
        print_r(json_encode(array('status' => "false", 'error' => 'Task add Fail.')));
    }
} else {
	print_r(json_encode(array('status' => "false", 'error' => 'Request is not Proper.')));
}