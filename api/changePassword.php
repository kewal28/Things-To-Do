<?php

require 'connection.php';

if (isset($_POST) && !empty($_POST)) {
    extract($_POST);
    $row = mysql_query("SELECT * FROM user WHERE password='$oldPassword' and userId='$userId' ");
    $count = mysql_num_rows($row);
    if($count > 0) {
    $row = mysql_query("UPDATE `user` SET password='$password' WHERE userId='$userId'");
    	if ($row) {
        	print_r(json_encode(array('status' => "true",'error' => '')));
	    } else {
    	    print_r(json_encode(array('status' => "false", 'error' => 'Password Change fail.')));
	    }
    } else {
	    print_r(json_encode(array('status' => "false", 'error' => 'Old password not match.')));
    }
}