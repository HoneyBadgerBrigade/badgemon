var badger;
var femme;
var badgerCard;
var femmeCard;
var badgerAttacks = ["knowledge", "humour", "logic", "agency"];
var femmeAttacks = ["anecdote", "insult", "outrage", "damsel"];
var s_hit = new Audio("hit.wav");
var s_moans = ["moan.wav"];
var s_vol = 0.5;

function select(selected, mon) {
    document.getElementsByTagName("body")[0].style = "overflow-y: hidden";
    document.getElementById("box").style.display = "block";
    var b = document.getElementById("badgers").children;
    badgerCard = selected;
    badgerCard.classList.add("selected");
    badgerCard.removeAttribute("onclick");

    for(var i = 0; i < b.length; i++) {
        if(!b[i].classList.contains("selected"))
            b[i].style.display = "none";
    }

    badger = badgemon.find(x => x.name === mon);
    femme = femmemon[Math.floor(Math.random() * femmemon.length)];
    femmeCard = document.getElementById(femme.name);
    femmeCard.classList.remove("hidden");
    femmeCard.classList.add("selected");

    badger.hp = 3; femme.hp = 3;
    updateHP(badgerCard, badger.hp);
    updateHP(femmeCard, femme.hp);

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

    sleep(2000).then(() => { document.getElementById("box").classList.add("rise"); });
}

function updateHP(ent, amount) {
    for(i = 0; i < ent.children.length; ++i) {
        if(ent.children[i].className == "health") {
            ent.children[i].innerHTML = "";
            for(h = 0; h < amount; ++h) {
                ent.children[i].appendChild(document.createElement("img")).setAttribute("src", "i/emblem-favorite.svg");
            }
        }
    }
}

function attackFemme(stat) {
    var type = "";
    var success = false;
    if(badger.stats[badgerAttacks[stat]] > femme.stats[femmeAttacks[stat]]) { hit(femmeCard); success = true; updateHP(femmeCard, --femme.hp); }
    else if(badger.stats[badgerAttacks[stat]] < femme.stats[femmeAttacks[stat]]) { hit(badgerCard); updateHP(badgerCard, --badger.hp); }
    //else //Draw/parry

    displayMessage(stat, type, success);
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

function displayMessage(stat, type, success) {
    var buttons = document.getElementById("buttons").style;
    var msgbox = document.getElementById("msgbox");
    buttons.opacity = "0";
    buttons.display = "none";
    msgbox.style.display = "block";

    var rand = Math.floor(Math.random() * messages[badgerAttacks[stat]].length);
    var message = messages[badgerAttacks[stat]][rand];

    message = message.replace("%bname%", badger["name"]);
    message = message.replace("%fname%", femme["name"]);

    if(!success) message += "<br/>It wasn't very effective...";

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

/*function setCookie(c_name, value) {
    var c_value = escape(value);
    document.cookie = c_name + "=" + c_value;
}

function getCookie(c_name) {
    var c_value = document.cookie;
    var c_start = c_value.indexOf(" " + c_name + "=");
    if (c_start == -1) c_start = c_value.indexOf(c_name + "=");
    if (c_start == -1) c_value = null;
    else {
        c_start = c_value.indexOf("=", c_start) + 1;
        var c_end = c_value.indexOf(";", c_start);
        if (c_end == -1) c_end = c_value.length;
        c_value = unescape(c_value.substring(c_start,c_end));
    }
    return c_value;
}

function checkCookie() {
    var time = getCookie("time");
    if (time != null && time != "") count = parseInt(time);
    else count = 0;
}*/
