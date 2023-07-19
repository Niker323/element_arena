var lll = false;
var pninfo = [];
pninfo[0] = [];
pninfo[1] = [];
pninfo[2] = [];
pninfo[3] = [];
pninfo[4] = [];
var prinfo = [];
prinfo[0] = [0,0,0,0,0,0,0,0,0,0];
prinfo[1] = [0,1,0,0,0,0,0,0,0,0];
prinfo[2] = [0,2,0,0,0,0,0,0,0,0];
prinfo[3] = [0,3,0,0,0,0,0,0,0,0];
prinfo[4] = [0,4,0,0,0,0,0,0,0,0];
var ids = [];
var nowselected = Players.GetLocalPlayer();
function Yes()
{
    //$.Msg();
    if (lll == true)
    {
        //$("#Profile").visible = false;
        //$("#Profile").SwitchClass("CreatePanelClass","OffPanelClass");
        $("#MaxProfile").RemoveClass("CreatePanelClass");
        $("#MaxProfile").AddClass("OffPanelClass");
        lll = false;
        nowselected = Players.GetLocalPlayer();
        //$.Msg("1");
    }
    else
    {
        if ($("#MaxProfile").visible == false)
        {
            $("#MaxProfile").visible = true;
        }
        $("#MaxProfile").RemoveClass("OffPanelClass");
        $("#MaxProfile").AddClass("CreatePanelClass");
        lll = true;
        nowselected = Players.GetLocalPlayer();
        UpdateMyProfile(Players.GetLocalPlayer());
    }
}

function Close()
{
    $("#MaxProfile").RemoveClass("CreatePanelClass");
    $("#MaxProfile").AddClass("OffPanelClass");
    lll = false;
    nowselected = Players.GetLocalPlayer();
}

var heroids = new Array(63,18,8,2,49,29,35,94,11,99,96,6,46,48,22,25,104,52,72,40,30,77,102,47,95,28,57,5,44,56,83,79,50,64,21,84,112,87,75,15,59,23,32,71,51,14,60,61,119,65,26,68,3,111,16,89,120,43,107,39,20,9,106,1,100,31);
function UpdateMyProfile(id)
{
    //$.Msg(id);
    
    $("#spba0").visible = false;
    $("#spba1").visible = false;
    $("#spba2").visible = false;
    $("#spba3").visible = false;
    $("#spba4").visible = false;
    $("#spba"+id).visible = true;

    $("#ava").steamid = ids[id];
    $("#UserName").steamid = ids[id];

    for (var i = 0; i < heroids.length;i++)
    {
        $("#hero"+heroids[i]).RemoveClass("Heroes2");
        $("#hero"+heroids[i]).AddClass("Heroes");
        //$("#hero"+heroids[i]).SwitchClass("Heroes2", "Heroes");
    }

    for (var i = 0; i <= 4;i++)
    {
        //$.Msg(pninfo);
        if (pninfo[i] != null)
        {
            if (pninfo[i][1] == id)
            {
                $("#plays").text = $.Localize("#lplays")+pninfo[i][2];
                $("#wins").text = $.Localize("#lwins")+pninfo[i][3];
                $("#hardwins").text = $.Localize("#lhardwins")+pninfo[i][4];
                for (var y = 5; y <= heroids.length+4;y++)
                {
                    if (pninfo[i][y] == "1")
                    {
                        $("#hero"+heroids[y-5]).RemoveClass("Heroes");
                        $("#hero"+heroids[y-5]).AddClass("Heroes2");
                    }
                }
            }
            //$.Msg(prinfo);
            if (prinfo[i][1] == id)
            {
                for (var y = 2; y <= 9;y++)
                {
                    $("#lvlmyitemtext"+(y-1)).text = prinfo[i][y];
                    //$.Msg(y,prinfo[i][y]);
                }
            }
        }
    }
}

function UpdateMyInfo(data)
{
    //$.Msg(data);
    pninfo[data[1]] = data;
    UpdateMyProfile(nowselected);
}

function UpdtLvl(info)
{
    //$.Msg(info);
    prinfo[info[1]] = info;
    UpdateMyProfile(nowselected);
}

function SelectPl(id)
{
    if (id != nowselected)
    {
        nowselected = id;
        $("#lvlmyitemtext1").text = "-";
        $("#lvlmyitemtext2").text = "-";
        $("#lvlmyitemtext3").text = "-";
        $("#lvlmyitemtext4").text = "-";
        $("#lvlmyitemtext5").text = "-";
        $("#lvlmyitemtext6").text = "-";
        $("#lvlmyitemtext7").text = "-";
        $("#lvlmyitemtext8").text = "-";
        $("#wins").text = $.Localize("#lwins")+"-";
        $("#plays").text = $.Localize("#lplays")+"-";
        UpdateMyProfile(id);
    }
}

function OnSteamIds(myids)
{
    //$.Msg(myids);
    for (var i = 0; i < 5;i++)
    {
        if (myids[i] != null)
        {
            ids[i] = myids[i]["1"];
            $("#plhero"+i).heroname = myids[i]["2"];
            $("#SelPlButton"+i).visible = true;
        }
    }
    //$.Msg(ids);
}

(function()
{
    GameEvents.Subscribe( "MyProfileInfo", UpdateMyInfo)
    GameEvents.Subscribe( "My_lvl", UpdtLvl);
    GameEvents.Subscribe( "SteamIds", OnSteamIds);
    for (var x = 1; x < heroids.length+1; x = x + 1)
    {
        var mtop = 32*Math.floor((x-1)/11);
        var mleft = 32*(x-1)-352*Math.floor((x-1)/11);
        $("#ProfileHeroes").BCreateChildren("<DOTAHeroImage id='hero"+heroids[x-1]+"' class='Heroes' heroid='"+heroids[x-1]+"' heroimagestyle='icon' style='height:32px;width:32px; margin-top:"+mtop+"px; margin-left:"+mleft+"px;'/>");
    }
    $("#MaxProfile").visible = false;
    $("#SelPlButton0").visible = false;
    $("#SelPlButton1").visible = false;
    $("#SelPlButton2").visible = false;
    $("#SelPlButton3").visible = false;
    $("#SelPlButton4").visible = false;
    $("#spba0").visible = false;
    $("#spba1").visible = false;
    $("#spba2").visible = false;
    $("#spba3").visible = false;
    $("#spba4").visible = false;
    $("#MaxProfile").AddClass("OffPanelClass");
    GameEvents.SendCustomGameEventToServer( "Levels", { id: 0} );
    GameEvents.SendCustomGameEventToServer( "Levels", { id: 1} );
    GameEvents.SendCustomGameEventToServer( "Levels", { id: 2} );
    GameEvents.SendCustomGameEventToServer( "Levels", { id: 3} );
    GameEvents.SendCustomGameEventToServer( "Levels", { id: 4} );
    GameEvents.SendCustomGameEventToServer( "UpdateProfiles", {id:Players.GetLocalPlayer()} );
})();