var crafts = [
    [2,5,9],
    [9,6,5],
    [8,5,10],
    [8,6,7],
    [2,8,6],
    [4,2,7],
    [4,10,3],
    [3,5,4],
    [2,5,3],
    [1,10,8],
    [4,7,1],
    [10,9,1],
    [3,6,10],
    [9,3,7],
    [7,1,5],
    [7,2,10],
    [4,9,8],
    [9,6,1],
    [4,6,2],
    [1,8,3],
    [7,8,3],
    [10,7,3],
    [9,10,4],
    [2,8,9],
    [1,2,3],
    [1,5,2],
    [5,8,4],
    [7,9,6],
    [5,10,6],
    [1,6,4]
];

var elems = ["item_ice","item_fire","item_water","item_energy","item_earth","item_life","item_void","item_air","item_light","item_shadow"];
var items = ["item_light_fire_earth","item_light_life_earth","item_air_earth_shadow","item_air_life_void","item_air_fire_life","item_energy_fire_void","item_energy_shadow_water","item_energy_earth_water","item_fire_earth_water","item_ice_shadow_air","item_energy_void_ice","item_shadow_light_ice","item_water_life_shadow","item_light_water_void","item_void_ice_earth","item_void_fire_shadow","item_energy_light_air","item_light_life_ice","item_energy_life_fire","item_ice_air_water","item_air_void_water","item_void_shadow_water","item_shadow_energy_light","item_air_fire_light","item_water_ice_fire","item_ice_fire_earth","item_air_earth_energy","item_void_light_life","item_earth_shadow_life","item_ice_life_energy"];
var x3mode = false;

function Open()
{
    //$.Msg();
    if ($("#Shop").visible == true)
    {
        $("#Shop").visible = false;
        $("#ShopInfo").visible = false;
    }
    else
    {
        $("#Shop").visible = true;
        $("#ShopInfo").visible = true;
        if ($("#ShopInfo").BHasClass("ShopInfoAnim"))
        {
            $("#ShopInfo").RemoveClass("ShopInfoAnim");
            $("#ShopInfo").AddClass("ShopInfoAnim");
        }
        //GameEvents.SendCustomGameEventToServer( "Levels", { id: Players.GetLocalPlayer()} );
    }
    $("#readytext").RemoveClass("ElementShopText");
}

function OffInfo()
{
    $("#ShopInfo").RemoveClass("ShopInfoAnim");
    $("#ShopInfo").AddClass("ShopInfoAnim2");
}

function OnInfo()
{
    if ($("#ShopInfo").BHasClass("ShopInfoAnim"))
    {
        $("#ShopInfo").RemoveClass("ShopInfoAnim");
        $("#ShopInfo").AddClass("ShopInfoAnim2");
    }
    else
    {
        $("#ShopInfo").RemoveClass("ShopInfoAnim2");
        $("#ShopInfo").AddClass("ShopInfoAnim");
    }
}

function ToggleX3mode()
{
    if (x3mode == true)
    {
        x3mode = false
        $("#ToggleX3mode").RemoveClass("selectedfilter");
    }
    else
    {
        x3mode = true
        $("#ToggleX3mode").AddClass("selectedfilter");
    }
    UpdateShop( "Elements_Tabel", Players.GetLocalPlayer(), CustomNetTables.GetTableValue( "Elements_Tabel", Players.GetLocalPlayer() ) );
}

function Buy(myint)
{
	//$.Msg( "Buy ", $("#myitem1").itemname);
	GameEvents.SendCustomGameEventToServer( "Buy_Element", {num:myint} );
}

function BuyItem(myint)
{
	//$.Msg( "Buy ", $("#myitem1").itemname);
    for (var i = 0; i < 3;i++)
    {
        GameEvents.SendCustomGameEventToServer( "Buy_Element", {num:crafts[myint-1][i]} );
    }
}

function UpdateShop( table_name, key, data )
{
    var ID = Players.GetLocalPlayer();
	//$.Msg( ID, ": ", "Table ", table_name, " changed: '", key, "' = ", data );
    if (ID == key)
    {
        for (var i = 1; i <= 10;i++)
        {
            if (data[i] != null)
            {
                $("#lvlmyitemtext"+i).text = "x "+data[i];
            }
        }
        for (var y = 1; y <= 30;y++)
        {
            $("#craft"+y).RemoveClass("offcraft");
            for (var i = 0; i <= 2;i++)
            {
                if (x3mode == true)
                {
                    if (data[crafts[y-1][i]] < 3)
                    {
                        $("#craft"+y).AddClass("offcraft");
                        break;
                    }
                }
                else
                {
                    if (data[crafts[y-1][i]] == 0)
                    {
                        $("#craft"+y).AddClass("offcraft");
                        break;
                    }
                }
            }
        }
    }
}

(function()
{
    CustomNetTables.SubscribeNetTableListener( "Elements_Tabel", UpdateShop );
    // $("#Shop").visible = false;
    // $("#ShopInfo").visible = false;
    for (var i = 1; i <= 30;i++)
    {
        var mtop = 10+38*(i-1)-380*Math.floor((i-1)/10);
        var mleft = 15+270*Math.floor((i-1)/10);
        $("#ShopInfo").BCreateChildren("<Panel hittest='false' id='craft"+i+"'/>");
        $("#craft"+i).BCreateChildren("<DOTAItemImage itemname='"+elems[crafts[i-1][0]-1]+"' style='height:32px;width:44px; margin-top:"+mtop+"px; margin-left:"+mleft+"px;' onactivate='Buy("+crafts[i-1][0]+")'/>");
        $("#craft"+i).BCreateChildren("<DOTAItemImage itemname='"+elems[crafts[i-1][1]-1]+"' style='height:32px;width:44px; margin-top:"+mtop+"px; margin-left:"+(mleft+50)+"px;' onactivate='Buy("+crafts[i-1][1]+")'/>");
        $("#craft"+i).BCreateChildren("<DOTAItemImage itemname='"+elems[crafts[i-1][2]-1]+"' style='height:32px;width:44px; margin-top:"+mtop+"px; margin-left:"+(mleft+100)+"px;' onactivate='Buy("+crafts[i-1][2]+")'/>");
        $("#craft"+i).BCreateChildren("<Image src='file://{images}/custom_game/game_info/str.png' style='height:32px;width:32px; margin-top:"+mtop+"px; margin-left:"+(mleft+150)+"px;'/>");
        $("#craft"+i).BCreateChildren("<DOTAItemImage itemname='"+items[i-1]+"' style='height:32px;width:44px; margin-top:"+mtop+"px; margin-left:"+(mleft+190)+"px;' onactivate='BuyItem("+i+")'/>");
    }
    UpdateShop( "Elements_Tabel", Players.GetLocalPlayer(), CustomNetTables.GetTableValue( "Elements_Tabel", Players.GetLocalPlayer() ) )
})();