var badger;
var femme;
var badgerCard;
var femmeCard;
var badgerAttacks = ["knowledge", "humour", "logic", "agency"];
var femmeAttacks = ["anecdote", "insult", "outrage", "damsel"];
var s_hit = new Audio("hit.wav");
var bgm = new Audio("mus_battle1.wav");
bgm.loop = true;
bgm.volume = 0.25;
//var s_moans = ["moan.wav"];
var s_vol = 0.25;
var showButtons = true;
var gameOver = false;

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
    femme = femmemon;
    femmeCard = document.getElementById(femme.name);
    femmeCard.classList.remove("hidden");
    femmeCard.classList.add("selected");

    badger.hp = 3; femme.hp = 3;
    updateHP(badgerCard, badger.hp);
    updateHP(femmeCard, femme.hp);

    document.getElementById("title").innerHTML = badger.name + " vs. " + femme.name;
    bgm.play();

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

    var btns = document.getElementById("buttons").style;
    btns.display = "none";
    sleep(2000).then(() => { 
        document.getElementById("box").classList.add("rise");
        sleep(1000).then(() => {
            if(femme.initiative >= badger.initiative) attackBadger();
            else btns.display = "block";
        });
    });
}

function updateHP(ent, amount) {
    for(i = 0; i < ent.children.length; ++i) {
        if(ent.children[i].className == "health") {
            ent.children[i].innerHTML = "";
            for(h = 0; h < 3; ++h) {
                var elem = ent.children[i].appendChild(document.createElement("img"));
                elem.setAttribute("src", "i/heart.svg");
                if(h >= amount) elem.setAttribute("style", "opacity: 0;");
            }
        }
    }
}

//called whenever a femmémon attacks before it makes a hit. It'll return whether the counter succeeds or not.
function counter() {

    return false;
}

//called by femmémon when they attack badgemons
function attackBadger() {
    var type = "";
    var success = false;
    var def = false;
    playerLastAttack = false;
    var selectedStat = 0;

    //always select strongest stat
    for(i = 0; i < 4; ++i) {
        if(femme.stats[femmeAttacks[i]] >= femme.stats[femmeAttacks[selectedStat]])
            selectedStat = i;
    }

    //calculate if special is used
    if(femme.hp == 1 && !Math.floor(Math.random() * 100 - (femme.initiative * 5))) {
        type = "special";
        hit(badgeCard);
        updateHP(badgeCard, 0); //instakill
        displayMessage(femmeAttacks[selectedStat], type, success, def);
        return;
    }

    if(badger.stats[badgerAttacks[selectedStat]] > femme.stats[femmeAttacks[selectedStat]]) {
        hit(femmeCard);
        //updateHP(femmeCard, --femme.hp);
        femme.stats[femmeAttacks[selectedStat]]++;
        def = true;
    }
    else if(badger.stats[badgerAttacks[selectedStat]] < femme.stats[femmeAttacks[selectedStat]]) {
        hit(badgerCard);
        updateHP(badgerCard, --badger.hp);
        success = true;
    }
    else {
        type = "parry";
        success = true;
    }

    displayMessage(femmeAttacks[selectedStat], type, success, def);
}

//called by the user/badgemon when they attack femmemons
function attackFemme(stat) {
    var type = "";
    var success = false;
    var def = false;
    playerLastAttack = true;

    //calculate if special is used
    if(badger.hp == 1 && !Math.floor(Math.random() * 100 - (badger.initiative * 5))) {
        type = "special";
        hit(femmeCard);
        updateHP(femmeCard, 0); //instakill
        displayMessage(badgerAttacks[stat], type, success, def);
        return;
    }

    if(badger.stats[badgerAttacks[stat]] > femme.stats[femmeAttacks[stat]]) {
        def = true;
        success = true;
        hit(femmeCard);
        updateHP(femmeCard, --femme.hp);
        femme.stats[femmeAttacks[stat]]++;
    }
    else if(badger.stats[badgerAttacks[stat]] < femme.stats[femmeAttacks[stat]]) {
        hit(badgerCard);
        //updateHP(badgerCard, --badger.hp);
    }
    else {
        type = "parry";
        success = false;
    }

    displayMessage(badgerAttacks[stat], type, success, def);
}

function battleOver(win) {
    showButtons = false;
    gameOver = true;
    displayMessage("knowledge", "win", win);
}

function hit(ent) {
    ent.classList.add("hit");
    s_hit.volume = s_vol;
    s_hit.play();
    //var s_moan = new Audio(s_moans[Math.floor(Math.random() * s_moans.length)]);
    //s_moan.volume = s_vol;
    //s_moan.play();
    sleep(500).then (() => {
        ent.classList.remove("hit");
    });
}

function displayMessage(stat, type, success, def) {
    var buttons = document.getElementById("buttons").style;
    var msgbox = document.getElementById("msgbox");
    buttons.opacity = "0";
    sleep(200).then(() => {
        buttons.display = "none";
        msgbox.style.display = "block";
    });

    var rand = Math.floor(Math.random() * messages[stat].length);
    var message = messages[stat][rand];

    if(type == "win") {
        message = "";
        if(success) message += badger.messages.win + "<br/><br/>" + femme.messages.lose;
        else message += femme.messages.win + "<br/><br/>" + badger.messages.lose;
        //after some time, or present an X, return user to sims page.
    }
    else if(type == "parry") {
        if(success) message += "<br/><br/>%bname% parried the attack.";
        else message += "<br/><br/>%fname% parried the attack."
    }
    else if(type == "") {
        if(!success) message += "<br/>It wasn't very effective...";
        else if(def) message += "<br/>%fname% gets stronger against these attacks!";
    }

    message = message.replace(/%bname%/g, badger["name"]);
    message = message.replace(/%fname%/g, femme["name"]);

    //make text appear one character at a time
    sleep(300).then(() => {
        var i = 0;
        function loop() {
            sleep(10).then(() => { //with a delay of 10ms between characters
                msgbox.innerHTML = message.substring(0, i);
                i++;
                if(i <= message.length) {
                    loop();
                }
                else {
                    sleep(3500).then(() => { //then hide the message 3.5s after the last character is shown
                        if(showButtons) {
                            msgbox.innerHTML = "";
                            msgbox.style.display = "none";
                            buttons.display = "block";
                            buttons.opacity = "1";
                        }

                        if(femme.hp <= 0 && !gameOver) battleOver(true);
                        else if(badger.hp <= 0 && !gameOver) battleOver(false);
                        else {
                            if(playerLastAttack && !gameOver) { attackBadger(); }
                        }
                    });
                }
            });
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
