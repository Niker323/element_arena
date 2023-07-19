var list = [];
var skiponetick = false
function AddRSUI( data )
{
    $.Msg(data);
    list.push(data);
}

function IntTick()
{
    if (skiponetick == false)
    {
        if ($("#PanelForPart") != null)
        {
            //$("#immortalpart").visible = false;
            //$("#immortalpart").DeleteAsync(0);
            $("#PanelForPart").RemoveAndDeleteChildren();
            //$("#immortalpart").visible = true;
        }
        if (list[0] != null)
        {
            $("#Line1").visible = true;
            if ($("#item1") != null)
            {
                $("#item1").RemoveAndDeleteChildren();
            }
            if ($("#Line1").BHasClass("OffPanelClass"))
                $("#Line1").RemoveClass("OffPanelClass");
            if ($("#Line1").BHasClass("OffPanelClassImm"))
                $("#Line1").RemoveClass("OffPanelClassImm");

            switch(list[0]["rsid"].charAt(0)) {
                case '1':
                rares = "shards";
                myclass = "common";
                break
            
                case '2':
                rares = "stones";
                myclass = "rare";
                break
            
                case '3':
                rares = "crystals";
                myclass = "mythical";
                break
            
                case '4':
                rares = "clusters";
                myclass = "immortal";
                skiponetick = true;
                break
            }
            if (myclass == "immortal")
            {
                $("#PanelForPart").BCreateChildren("<DOTAScenePanel hittest='false' id='immortalpart' particleonly='true' style='margin-top:-135px; margin-left:-52px; height:300px;width:300px;' map='cameras' camera='partcamera4' />");
            }
            if (myclass == "immortal")
            {
                $("#Line1").AddClass("OffPanelClassImm");
            }
            else
            {
                $("#Line1").AddClass("OffPanelClass");
            }
            switch(list[0]["rsid"].charAt(1)) {
                case '0':
                elem = "ice";
                break
            
                case '1':
                elem = "fire";
                break
            
                case '2':
                elem = "water";
                break
            
                case '3':
                elem = "energy";
                break
            
                case '4':
                elem = "earth";
                break
            
                case '5':
                elem = "life";
                break
            
                case '6':
                elem = "void";
                break
            
                case '7':
                elem = "air";
                break
            
                case '8':
                elem = "light";
                break
            
                case '9':
                elem = "shadow";
                break
            }
            $("#hero1").heroname = list[0]["hero"];
            $("#Line1").BCreateChildren("<Panel hittest='false' id='item1' style='margin-top:4px; margin-left:82px;' onmouseover='UIShowCustomLayoutParametersTooltip(RSTooltip,file://{resources}/layout/custom_game/rs_tooltips.xml,num="+list[0]["rsid"]+")' onmouseout='UIHideCustomLayoutTooltip(RSTooltip)'/>");
            $("#item1").BCreateChildren("<Image src='file://{images}/custom_game/relic_items/"+rares+"/"+elem+"/"+list[0]["rsid"].charAt(2)+".png' style='height:36px;width:48px;'/>");
            $("#item1").BCreateChildren("<Panel hittest='false' class='"+myclass+"' style='height:36px;width:3px; margin-left:48px;'/>");
            list.shift();
            //$("#immortalpart").visible = true;
            //$.Msg(list);
        }
        else
        {
            $("#Line1").visible = false;
        }
    }
    else
    {
        skiponetick = false;
    }
    $.Schedule(4,IntTick);
}

(function()
{
    $("#Line1").visible = false;
    GameEvents.Subscribe( "AddRSUI", AddRSUI);
    IntTick();
})();