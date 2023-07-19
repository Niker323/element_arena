function Ok()
{
	$("#endswaves").visible = false;
}

function open()
{
	$("#endswaves").visible = true;
}

(function()
{
    GameEvents.Subscribe( "endswaves", open)
    
    $("#endswaves").visible = false;
})();