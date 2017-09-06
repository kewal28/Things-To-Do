<?php

require 'connection.php';

if (isset($_POST["taskId"]) && !empty($_POST["taskId"])) {
    extract($_POST);
$task = mysql_query("SELECT * FROM tasks WHERE id = '$taskId'");
$count = mysql_num_rows($task);
if ($count > 0) {
    $array['error'] = "";
    $task = mysql_query("DELETE FROM tasks WHERE id = '$taskId'");
    $array['status'] = "true";
} else {
    $array['status'] = "false";
    $array['error'] = "No tasks Found";
}
}

print_r(json_encode($array));
