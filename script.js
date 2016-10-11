var badger;
var femme;
var selectedBadger;

function select(selected, mon) {
    document.getElementById("box").style.display = "block";
    var b = document.getElementById("badgers").children;
    selectedBadger = selected;
    selectedBadger.classList.add("selected");

    for(var i = 0; i < b.length; i++) {
        if(!b[i].classList.contains("selected"))
            b[i].style.display = "none";
    }

    badger = badgemon.find(x => x.name === mon);
    femme = femmemon[Math.floor(Math.random() * femmemon.length)];

    badger.hp = 3; femme.hp = 3;

    document.getElementById("title").innerHTML = badger.name + " vs. " + femme.name;

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

    hit(selectedBadger);

    displayMessage(stat, type);
}

function hit(ent) {
    ent.classList.add("hit");
    sleep(500).then (() => {
        ent.classList.remove("hit");
    });
}

function displayMessage(stat, type) {
    var buttons = document.getElementById("buttons").style;
    buttons.opacity = "0";
    //buttons.display = "none";

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
                        //buttons.display = "block";
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
