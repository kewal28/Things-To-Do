<?php

require 'connection.php';

if (isset($_POST) && !empty($_POST)) {
    extract($_POST);
    $row = mysql_query("SELECT * FROM user WHERE email='$forgetEmail' ");
    $count = mysql_num_rows($row);
    if($count > 0) {
	$result = mysql_fetch_array($row);
	$to = $result["email"];
	$subject = "Login details of thing to do app.";
	$msg = "
	Dear {$result['name']},

	Your login details are given below:-
	Email:- {$result['email']}
	Password:- {$result['password']}
	
	Things To Do Support Team
	";
	if(mail($to,$subject,$msg)) {
	    print_r(json_encode(array('status' => "true",'error' => '')));
	}
    } else {
	    print_r(json_encode(array('status' => "false", 'error' => 'User not found.')));
    }
}