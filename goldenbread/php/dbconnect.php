<?php
$servername = "localhost";
$username   = "seriousl_goldenbreadadmin";
$password   = "0qh&qrgcMi&$";
$dbname     = "seriousl_goldenbread";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
   die("Connection failed: " . $conn->connect_error);
}
?>