<?php
error_reporting(0);
include_once("dbconnect.php");
$prid = $_POST['prid'];
$prname = ucwords($_POST['prname']);
$quantity = $_POST['quantity'];
$price = $_POST['price'];
$type = $_POST['type'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../productimage/'.$prid.'.jpg';

    $sqlupdate = "UPDATE PRODUCT SET NAME ='$prname', QUANTITY = '$quantity', PRICE = '$price', TYPE = '$type' WHERE ID = '$prid'";
    if ($conn->query($sqlupdate) === true)
    {
        if (isset($encoded_string)){
            file_put_contents($path, $decoded_string);
        }
        echo "success";
    }
    else
    {
        echo "failed";
    }

$conn->close();
?>