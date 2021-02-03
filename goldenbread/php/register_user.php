<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

    $sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,CREDIT,VERIFY) VALUES ('$name','$email','$password','$phone','0','0')";
    if ($conn->query($sqlinsert) === TRUE) {
        sendEmail($email);
        echo "success";
    } else {
        echo "failed";
    }
    

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for GoldenBread'; 
    $message = 'http://seriouslaa.com/goldenbread/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@goldenbread.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>