<?php

require 'connection.php';

if (isset($_POST) && !empty($_POST)) {
    extract($_POST);
    $row = mysql_query("SELECT * FROM user WHERE email='$email' ");
    $count = mysql_num_rows($row);
    if($count == 0) {
    $row = mysql_query("INSERT INTO `user` (`userId`,`name`, `email`, `mobile`, `password`, `status`) VALUES ('$userId','$name', '$email', '$phoneno', '$password', '1')");
    	if ($row) {
    		$raw = mysql_query("SELECT * FROM user WHERE email='$email' ");
    		$result = mysql_fetch_array($raw);
        	print_r(json_encode(array('status' => "true","userId" => $result['userId'], "emailId" => $result['email'],'sessionToken' => md5(rand()), 'error' => '')));
	    } else {
    	    print_r(json_encode(array('status' => "false", 'error' => 'Signup fail.')));
	    }
    } else {
	    print_r(json_encode(array('status' => "false", 'error' => 'User already exist.')));
    }
}