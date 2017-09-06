<?php

require 'connection.php';

if (isset($_POST) && !empty($_POST)) {
    $row = mysql_query("SELECT * FROM user WHERE email='{$_POST['email']}' and password='{$_POST['password']}' ");
    $count = mysql_num_rows($row);
    if($count > 0) {
        $result = mysql_fetch_array($row);
    	print_r(json_encode(array('status' => "true" , "userId" => $result['userId'], "emailId" => $result['email'], 'sessionToken' => md5(rand()), 'error' => '')));
    } else {
    	print_r(json_encode(array('status' => "false",'error' => 'Invalid details.')));
    }
}