var badger;
var femme;
var selectedBadger;
var s_hit = new Audio("hit.wav");
var s_moans = ["moan.wav"];
var s_vol = 0.5;


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
    s_hit.volume = s_vol;
    s_hit.play();
    var s_moan = new Audio(s_moans[Math.floor(Math.random() * s_moans.length)]);
    s_moan.volume = s_vol;
    s_moan.play();
    sleep(500).then (() => {
        ent.classList.remove("hit");
    });
}

function displayMessage(stat, type) {
    var buttons = document.getElementById("buttons").style;
    var msgbox = document.getElementById("msgbox");
    buttons.opacity = "0";
    buttons.display = "none";
    msgbox.style.display = "block";

    var rand = Math.floor(Math.random() * messages[stat].length);
    var message = messages[stat][rand];

    message = message.replace("%bname%", badger["name"]);
    message = message.replace("%fname%", femme["name"]);

    sleep(300).then (() => {
        var i = 0;
        function loop() {
            setTimeout(function() {
                msgbox.innerHTML = message.substring(0, i);
                i++;
                if(i <= message.length) {
                    loop();
                }
                else {
                    sleep(2500).then (() => {
                        msgbox.innerHTML = "";
                        msgbox.style.display = "none";
                        buttons.display = "block";
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
