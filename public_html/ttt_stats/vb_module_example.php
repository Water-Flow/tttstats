/*------------------------\
|        TTT STATS        |
|	       Beta           |
|=========================|
|� 2013 SNGaming.org      |
|	All Rights Reserved   |
|=========================|
| 	Website printout      |
| 	   beta testing       |
| 	   by Handy_man       |
\------------------------*/
/*
*
* This code can be placed into a VBulliten "Forum block" found in the "Forum Blocks Manager" in your adminCP
* You're required to change the hostname, username, password and database select (if you've gone away from ttt_stats)
* This file assumes that you've placed the icon images found in the github repository /static/images into your public_html/images folder of your webhost
* This file is setup to read from that directory, this can easily be changed to your own desired location by changing the lines 67 - 73 with the relevent resources location.
*
*/



/*SQL connection/ configuration goes here */

$connect = mysql_connect("hostname", "username", "password");
$db_select = mysql_select_db('ttt_stats');
if (!connect) {

	die('ERROR, Contact Handy_man immediately' . mysql_error());
	
}

/*SQL connection/ configuration end here */


$var1 = mysql_query('SELECT * FROM `ttt_stats');
$uniqueusers = mysql_num_rows($var1);

$kills = mysql_query('SELECT SUM(kills) FROM ttt_stats');
$killsarray = mysql_fetch_array($kills);
$killstotal = array_sum($killsarray);

$innocent = mysql_query('SELECT SUM(innocenttimes) FROM ttt_stats');
$innocentarray = mysql_fetch_array($innocent);
$innocenttotal = array_sum($innocentarray);

$traitor = mysql_query('SELECT SUM(traitortimes) FROM ttt_stats');
$traitorarray = mysql_fetch_array($traitor);
$traitortotal = array_sum($traitorarray);

$detective = mysql_query('SELECT SUM(detectivetimes) FROM ttt_stats');
$detectivearray = mysql_fetch_array($detective);
$detectivetotal = array_sum($detectivearray);

$death = mysql_query('SELECT SUM(deaths) FROM ttt_stats');
$deatharray = mysql_fetch_array($death);
$deathtotal = array_sum($deatharray);

$kills = mysql_query('SELECT SUM(kills) FROM ttt_stats');
$killsarray = mysql_fetch_array($kills);
$killstotal = array_sum($killsarray);

$head = mysql_query('SELECT SUM(headshots) FROM ttt_stats');
$headarray = mysql_fetch_array($head);
$headtotal = array_sum($headarray);

$totalReturn = '<img src="../images/icon_id.png"> <font face="arial" color="#30a5f0">Unique Users:</font><font face="arial" color="#828282"> ' . $uniqueusers . '</font><br>';
$killsReturn = '<img src="../images/icon_bullet.png"> <font face="arial" color="#30a5f0">Players Killed:</font><font face="arial" color="#828282"> ' . $killstotal . '</font><br>';
$deathsReturn = '<img src="../images/icon_corpse.png"> <font face="arial" color="#30a5f0">Player Deaths:</font><font face="arial" color="#828282"> ' . $deathtotal . '</font><br>';
$headReturn = '<img src="../images/icon_head.png"> <font face="arial" color="#30a5f0">Headshots Made:</font><font face="arial" color="#828282"> ' . $headtotal . '</font><br>';
$detectiveReturn = '<img src="../images/icon_det.png"> <font face="arial" color="#30a5f0">Total Detectives:</font><font face="arial" color="#828282"> ' . $detectivetotal . '</font><br>';
$innocentReturn ='<img src="../images/icon_inno.png"> <font face="arial" color="#30a5f0">Total Innocents:</font><font face="arial" color="#828282"> ' . $innocenttotal . '</font><br>';
$traitorReturn = '<img src="../images/icon_traitor.png"> <font face="arial" color="#30a5f0">Total Traitors:</font><font face="arial" color="#828282"> ' . $traitortotal . '</font><br>';

return $killsReturn . $deathsReturn . $headReturn . $detectiveReturn . $innocentReturn . $traitorReturn;