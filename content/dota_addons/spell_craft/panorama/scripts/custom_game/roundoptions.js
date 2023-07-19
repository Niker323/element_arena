function HideButtons()
{
	$("#readytext").visible = false;
	$("#Vote_Yes").visible = false;
	$("#confirmation").visible = true;
}

function Yes()
{
	HideButtons();
	GameEvents.SendCustomGameEventToServer( "Vote_Round", {} );
}

function Toggle()
{
	GameEvents.SendCustomGameEventToServer( "ToggleAutoVote", { state: $("#Auto_Vote").checked} );
}

function UpdateVote(info)
{
    var id = info.id + 1
	$("#hero"+id+"_no").visible = false;
	$("#hero"+id+"_yes").visible = true;
}

function open(info)
{
    if ($("#RoundOptions").visible == false)
    {
        $("#RoundOptions").visible = true;
    }
    
    $("#RoundOptions").RemoveClass("OffPanelClass");
    $("#RoundOptions").AddClass("CreatePanelClass");
    
	$("#readytext").visible = true;
    $("#Vote_Yes").visible = true;
	$("#confirmation").visible = false;
    
	$("#hero1_yes").visible = false;
	$("#hero2_yes").visible = false;
	$("#hero3_yes").visible = false;
	$("#hero4_yes").visible = false;
	$("#hero5_yes").visible = false;
	$("#hero1_no").visible = false;
	$("#hero2_no").visible = false;
	$("#hero3_no").visible = false;
	$("#hero4_no").visible = false;
	$("#hero5_no").visible = false;
    
    var count = info.count
    
    for (var i = 1; i <= count;i++)
    {
        $("#hero"+i).heroname = Players.GetPlayerSelectedHero(i-1);
        $("#hero"+i+"_no").visible = true;
    }
}

function close()
{
    $("#RoundOptions").RemoveClass("CreatePanelClass");
    $("#RoundOptions").AddClass("OffPanelClass");
	//$("#RoundOptions").visible = false;
}

(function()
{
    GameEvents.Subscribe( "Display_RoundVote", open)
    GameEvents.Subscribe( "Close_RoundVote", close)
    GameEvents.Subscribe( "Update_Vote", UpdateVote)
    
	GameEvents.SendCustomGameEventToServer( "OnLoadPlayerVote", { } );
    
    $("#RoundOptions").visible = false;
})();