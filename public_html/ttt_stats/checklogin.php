<?PHP
require("./includes/session_start.php");

include("./includes/config.php");

// username and password sent from form
$myusername=$_POST['u'];
$mypassword=$_POST['p'];

// To protect MySQL injection (more detail about MySQL injection)
$myusername = mysql_real_escape_string($myusername);
$mypassword = mysql_real_escape_string($mypassword);

$check = mysql_query("SELECT * FROM admin_users WHERE user='$myusername' and pass=MD5('$mypassword')");
$users = mysql_num_rows($check);
$user_ip = $_SERVER['REMOTE_ADDR'];
if($users==1){
$update = mysql_query("UPDATE `handyman_ttt_stats`.`admin_users` SET `last_login` = now(), `last_ip` = '$user_ip' WHERE `admin_users`.`user` = '$myusername'");
$_SESSION['myusername'] = $myusername;
header('Location: http://www.thehiddennation.com/ttt_stats/login-success.php');
}
else {
echo "Wrong Username or Password";
}

?>