<?php
    /*
    System: Stats are compared against each other, stats versus each other in the current format:
    Statistics vs anecdote
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


    !!!!!!!!!!!! QUESTION:
    Could the chance of a special attack happen immediately as the battle starts?
    Should there be a character limit on biographies because of card size limitations?
    */

    $contents = file_get_contents("C:\\website\\zionfox\\hb\\mon.json");
    $mons = json_decode($contents, true);
    /*$contents = file_get_contents("C:\\website\\zionfox\\hb\\msgs.json");
    $messages = json_decode($contents, true);*/
    $contents = "";

    $rand = array_rand($mons["femmemon"]);
    $femme = $mons["femmemon"][$rand];
?>

<!DOCTYPE HTML>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Badgémon Game</title>
        <link rel="stylesheet" type="text/css" href="gamestyles.css" />
        <script type="text/javascript">
            var badgemon = <?php echo json_encode($mons["badgemon"]); ?>;
            var femmemon = <?php echo json_encode($mons["femmemon"]); ?>;
            var badger;
            var femme;

            function select(mon) {
                document.getElementById("box").style.display = "block";
                document.getElementById("badgers").style.display = "none";

                badger = badgemon.find(x => x.name === mon);
                femme = <?php echo json_encode($femme); ?>;

                badger.hp = 3; femme.hp = 3;

                var xmlhttp=new XMLHttpRequest();

                xmlhttp.onreadystatechange = function()
                {
                    if(xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        var json = JSON.parse(this.responseText);
                        window.messages = json;
                    }
                };
                xmlhttp.open("GET", "msgs.json", true);
                xmlhttp.send();
            }

            function attack(stat) {
                var type = "";

                displayMessage(stat, type);
            }

            function displayMessage(stat, type) {
                var buttons = document.getElementById("buttons").style;
                buttons.opacity = "0";
                buttons.zIndex = -1;

                var rand = Math.floor(Math.random() * messages[stat].length);
                var message = messages[stat][rand];

                message = message.replace("%bname%", badger["name"]);
                message = message.replace("%fname%", femme["name"]);

                sleep(300).then (() => {
                    var i = 0;
                    function loop() {
                        setTimeout(function() {
                            document.getElementById("msgbox").innerHTML = message.substring(0, i);
                            i++;
                            if(i <= message.length) {
                                loop();
                            }
                            else {
                                sleep(2500).then (() => {
                                    document.getElementById("msgbox").innerHTML = "";
                                    buttons.zIndex = 2;
                                    buttons.opacity = "1";
                                });
                            }
                        }, 10)
                    }

                    loop();
                });
            }

            function sleep(time) {
                return new Promise((resolve) => setTimeout(resolve, time));
            }
        </script>
    </head>

    <body>
        <?php
            asort($mons["badgemon"]);
            echo "<div id='badgers'>" .
                 "<h1>Choose your Badgémon!</h1>";
            foreach($mons["badgemon"] as $badger) {
                //TODO: CHECK TIER SYSTEM
                echo "<div class='box' onclick='select(\"" . $badger["name"] . "\");'>" .
                     "<h2>" . $badger["name"] . "</h2>" .
                     "<img src='" . $badger["img"] . "' alt='" . $badger["name"] . "' />" .
                     "<p>" . $badger["bio"] . "</p>" .
                     "<h3>Statistics</h3>" .
                     "<ul>";
                foreach($badger["stats"] as $stat => $val) {
                    if($stat != "mobility")
                        echo "<li>" . ucfirst($stat) . ": " . $val . "</li>";
                }
                echo "</ul></div>";
            }
            echo "</div>";
        ?>
        <div id="box">
            <div id="msgbox"></div>
            <div id="buttons">
                <ul>
                    <li onclick="attack('knowledge');">Knowledge</li>
                    <li onclick="attack('humour');">Humour</li>
                    <li onclick="attack('logic');">Logic</li>
                    <li onclick="attack('agency');">Agency</li>
                </ul>
            </div>
        </div>
    </body>
</html>
