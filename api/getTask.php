<?php

require 'connection.php';

$category = mysql_query("SELECT * FROM tasks WHERE userId='{$_GET['userId']}' ORDER BY id DESC LIMIT 20");
$count = mysql_num_rows($category);
if ($count > 0) {
    $array['error'] = "";
    while ($row = mysql_fetch_array($category)) {
        $array['tasks'][] = array('tasksId' => $row['id'], 'taskTitle' => $row['taskTitle'], 'taskDescription' => $row['taskDescription'], 'status' => $row['status']);
    }
    $array['status'] = "true";
} else {
    $array['status'] = "false";
    $array['error'] = "No tasks Found";
}

print_r(json_encode($array));
