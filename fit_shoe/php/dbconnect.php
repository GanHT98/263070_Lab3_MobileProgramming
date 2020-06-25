<?php $servername = "localhost"; 
$username   = "minempco_helperfitshoe"; 
$password   = "cVpL8]LBQZ*?";
$dbname     = "minempco_fitshoe"; 
 $conn = new mysqli($servername, $username, $password, $dbname); 
 if ($conn->connect_error) {     
 die("Connection failed: " . $conn->connect_error); } ?> 