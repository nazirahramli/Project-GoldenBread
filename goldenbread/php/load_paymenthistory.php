<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$date = $_POST['date'];

if (isset($email)){
    $sql = "SELECT * FROM PAYMENT WHERE USERID = '$email'";
}
if (isset($date)){
   $sql = "SELECT * FROM PAYMENT WHERE DATE LIKE  '%$date%'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["payment"] = array();
    while ($row = $result->fetch_assoc())
    {
        $paymentlist = array();
        $paymentlist["orderid"] = $row["ORDERID"];
        $paymentlist["billid"] = $row["BILLID"];
        $paymentlist["total"] = $row["TOTAL"];
        $paymentlist["date"] = $row["DATE"];
        array_push($response["payment"], $paymentlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>