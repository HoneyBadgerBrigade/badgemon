<?php
    /*
    System: Stats are compared against each other, stats versus each other in the current format:
    Knowledge vs anecdote
    Humour vs insult
    Logic vs outrage
    Agency vs damsel

    Both have Volume and Mobility stats, volume is a multiplier which applies to other stats, and mobility acts as initiative.
    Mobility for fememons are part of each 'mon and still act as the initiative. Mobility for the badgemon's will be fixed to the user, and act as the user's level.
    Both will have a pick from generic messages, and also specific messages per 'mon, each 'mon also has their own fatality messages, which are chosen on a winning hit against an opponent that's about to die.

    There is a level/tier system in place which is met per donation incentives. Higher tiers should not be available unless the incentive has been met, but should have access to lower tiers.
    <don't know if tier appearence will be chance based or not>

    Characters with equal power statistics when using specials need to be randomly chosen from either.
    When a special is used, if the versus statistic of the chosen special attack is the most powerful of the femmemon, it is instantly killed, otherwise it loses two hit points.

    //// Database Syntax
    SELECT user.name Username, badgemon.name Badgemon, femmemon.name Femmemon FROM `battle`
    INNER JOIN `badgemon` ON badgemon.id = battle.badgemon_id
    INNER JOIN `femmemon` ON femmemon.id = battle.femmemon_id
    INNER JOIN `user` ON user.token = battle.user_token
    WHERE `won` = 1


    !!!!!!!!!!!! QUESTION:
    Could the chance of a special attack happen immediately as the battle starts? ---- at 1hp, both should get special attacks.
    Should there be a character limit on biographies because of card size limitations? ---- Yes: determine character limit. (128 char)
    If a 'mon has custom messages, should they be used in place of generic messages, or in addition to and should they happen by random chance? ---- Use both custom and generic, and have preference over generic messages.

    ////////////
    For 4th Jan:
    mobility == initiative
    special only happens when attacker is on 1 life = 100 - (initiative * 5)
    femmemon stat bonus: femme loses and stat increases by 1.

    Finalise battle system, and ensure it works to standard.
    Finalise messaging system, and work out what needs to be said and when.
    */

    $config = parse_ini_file("config.ini");

    /*Database*/
    $dbHost = $config["dbHost"];
    $dbPort = $config["dbPort"];
    $dbUser = $config["dbUser"];
    $dbPass = $config["dbPass"];
    $dbConn = mysqli_connect($dbHost, $dbUser, $dbPass, $dbUser, $dbPort);

    $contents = file_get_contents("C:\\website\\zionfox\\hb\\mon.json");
    $mons = json_decode($contents, true);
    $contents = "";

    $uuid = strtolower(substr(com_create_guid(), 1, 36));
    //echo $uuid . "<br/>";

    if(mysqli_connect_errno())
        echo "Error connecting to MySQL Database: \"" . mysqli_connect_error() . "\"";
    else {
        /*Populate and utilise database here*/
    }
?>

<!DOCTYPE HTML>
<html>
    <head>
        <title>Badgémon Game</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <link rel="shortcut icon" href="i/favicon.png" />
        <link rel="stylesheet" type="text/css" href="gamestyles.css" />
        <link rel="stylesheet" type="text/css" href="gamesmall.css" media="screen and (max-width: 1280px) and (max-height: 1080px)" />
        <script type="text/javascript">
            var badgemon = <?php echo json_encode($mons["badgemon"]); ?>;
            var femmemon = <?php echo json_encode($mons["femmemon"]); ?>;
        </script>
        <script type="text/javascript" src="script.js"></script>
    </head>

    <body>
        <h1 id="title">Choose your Badgémon!</h1>
        <?php
            //Generate and print badgémon
            asort($mons["badgemon"]);
            echo "<div id='badgers'>";
            foreach($mons["badgemon"] as $badger) {
                //TODO: CHECK TIER SYSTEM
                echo "<div id='" . $badger["name"] . "' class='card' onclick='select(this, \"" . $badger["name"] . "\");'>" .
                     "<h2>" . $badger["name"] . "</h2>" .
                     "<img class='icon' src='" . $badger["img"] . "' alt='" . $badger["name"] . "' />" .
                     "<p>ini". $badger["initiative"] . "<br/>" . $badger["bio"] . "</p>" .
                     "<div class='health'></div>";/* .
                     "<h3>Statistics</h3>" .
                     "<ul>";
                foreach($badger["stats"] as $stat => $val) {
                    if($stat != "mobility")
                        echo "<li>" . ucfirst($stat) . ": " . $val . "</li>";
                }
                echo "</ul>*/echo "</div>";
            }
            echo "</div>";

            //Generate but hide femmémon
            asort($mons["femmemon"]);
            echo "<div id='femmes'>";
            foreach($mons["femmemon"] as $femme) {
                //TODO: Check tier System
                echo "<div id='" . $femme["name"] . "' class='card hidden'>" .
                     "<h2>" . $femme["name"] . "</h2>" .
                     "<img class='icon' src='" . $femme["img"] . "' alt='" . $femme["name"] . "' />" .
                     "<p>ini". $femme["initiative"] . "<br/>" . $femme["bio"] . "</p>" .
                     "<div class='health'></div>";/* .
                     "<h3>Statistics</h3>" .
                     "<ul>";
                foreach($femme["stats"] as $stat => $val) {
                    if($stat != "mobility" && $stat != "volume")
                        echo "<li>" . ucfirst($stat) . ": " . $val . "</li>";
                }
                echo "</ul>*/echo "</div>";
            }
            echo "</div>";
        ?>
        <div id="box">
            <div id="msgbox"></div>
            <div id="buttons">
                <ul>
                    <li onclick="attackFemme(0);">Knowledge</li>
                    <li onclick="attackFemme(1);">Humour</li>
                    <li onclick="attackFemme(2);">Logic</li>
                    <li onclick="attackFemme(3);">Agency</li>
                </ul>
            </div>
        </div>
    </body>
</html>
