<?php
error_reporting(0);
include_once("dbconnect.php");
$proid = $_POST['proid'];

$sqldelete = "DELETE FROM PRODUCT WHERE ID = '$proid'";
if ($conn->query($sqldelete)==TRUE){
    echo "success";
    
}else {
    echo "failed";
}
?>