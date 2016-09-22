<?php
    $contents = file_get_contents("C:\\website\\zionfox\\hb\\mon.json");
    $mons = json_decode($contents, true);
    $contents = file_get_contents("C:\\website\\zionfox\\hb\\msgs.json");
    $messages = json_decode($contents, true);
    $contents = "";

    //echo "Badgémon: </br>";
    $rand = array_rand($mons["badgemon"]); //Badgemon doesn't need to be randomised.
    $badger = $mons["badgemon"][$rand];
    $rand = array_rand($mons["femmemon"]);
    $femme = $mons["femmemon"][$rand];

    var_dump($badger);
    echo "</br>";
    var_dump($femme);
?>

<html>
    <head>
        <title>Testing JSON</title>
        <style>
            html, body {
                font-family: arial, helvetica, sans-serif;
                margin: 0px;
                padding: 0px;
            }
            #box {
                position: absolute;
                bottom: 0px;
                left: 0px;
                right: 0px;
                margin-left: auto;
                margin-right: auto;
                margin-bottom: 25px;
                padding: 20px;
                border: 4px solid #000000;
                height: 200px;
                width: 80%;
            }
            #buttons {
                transition: 0.3s;
            }
            #buttons ul {
                list-style: none;
            }
            #buttons ul li {
                display: inline-block;
                font-size: 2em;
                padding: 8px;
                margin: 10px 250px;
                border: 4px solid #000000;
                width: 200px;
                text-align: center;
                cursor: pointer;
            }
            #msgbox {
                text-align: center;
                font-size: 2em;
            }
        </style>
        <script type="text/javascript">
            var badger = <?php echo json_encode($badger); ?>;
            var femme = <?php echo json_encode($femme); ?>;

            function sleep(time) {
                return new Promise((resolve) => setTimeout(resolve, time));
            }

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

            function displayMessage(stat) {
                document.getElementById("buttons").style.opacity = "0";
                var rand = Math.floor(Math.random() * messages["generic"][stat].length);
                var message = messages["generic"][stat][rand];

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
                                    document.getElementById("buttons").style.opacity = "1";
                                });
                            }
                        }, 10)
                    }

                    loop();
                });
            }
        </script>
    </head>

    <body>
        <div id="box">
            <div id="msgbox"></div>
            <div id="buttons">
                <ul>
                    <li onclick="displayMessage('statistics');">Statistical</li>
                    <li onclick="displayMessage('humour');">Humourous</li>
                    <li onclick="displayMessage('logic');">Logical</li>
                    <li onclick="displayMessage('agency');">Agency</li>
                </ul>
            </div>
        </div>
    </body>
</html>
