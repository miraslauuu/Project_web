<?php

$server_nm = "LAPTOP-BJSNAIAH";
$connection = array("Database"=>"SVO_DB_PROJECT_FINAL_VERSION", "UID"=>"anhelina", "PWD"=>"Hfge!0406");
$conn = sqlsrv_connect($server_nm, $connection);

if($conn){
	echo"Connected!!\n";
}else{
	echo"Connection failed";
	die(print_r(sqlsrv_errors(),true));
}

