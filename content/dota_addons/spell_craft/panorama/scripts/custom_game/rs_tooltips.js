function setupTooltip(){
    var num = $.GetContextPanel().GetAttributeString( "num", "notfound" );
    $("#itemqual").visible = false;
    switch(num.charAt(0)) {
        case '1':
        rares = "SHARD";
        rare = "<font color='#FFFFFF'>common</font>";
        rarecolor = "#FFFFFF";
        break
      
        case '2':
        rares = "STONE";
        rare = "<font color='#4444FF'>rare</font>";
        rarecolor = "#4444FF";
        break
      
        case '3':
        rares = "CRYSTAL";
        rare = "<font color='#AA00AA'>mythical</font>";
        rarecolor = "#AA00AA";
        break
      
        case '4':
        rares = "CLUSTER";
        rare = "<font color='#E2AC38'>immortal</font>";
        rarecolor = "#E2AC38";
        $("#itemqual").visible = true;
        break
    }
    var elem = "";
    switch(num.charAt(1)) {
        case '0':
        elem = "ICE";
        break
      
        case '1':
        elem = "FIRE";
        break
      
        case '2':
        elem = "WATER";
        break
      
        case '3':
        elem = "ENERGY";
        break
      
        case '4':
        elem = "EARTH";
        break
      
        case '5':
        elem = "LIFE";
        break
      
        case '6':
        elem = "VOID";
        break
      
        case '7':
        elem = "AIR";
        break
      
        case '8':
        elem = "LIGHT";
        break
      
        case '9':
        elem = "SHADOW";
        break
    }
    var params = new Array(
        "",
        new Array("","+ <font color='#FFFFFF'>0.005</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.0015</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.001%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.0025</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.0015</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.0015%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.0025%</font> "+$.Localize("#relicmagdmg")),
        new Array("","+ <font color='#FFFFFF'>0.01</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.0025</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.0015%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.005</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.0025</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.0025%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.005%</font> "+$.Localize("#relicmagdmg")),
        new Array("","+ <font color='#FFFFFF'>0.01</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.0025</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.0015%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.005</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.0025</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.0025%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.005%</font> "+$.Localize("#relicmagdmg")),
        new Array(
            new Array("","+ <font color='#FFFFFF'>0.01</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.0025</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.0015%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.005</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.0025</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.0025%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.005%</font> "+$.Localize("#relicmagdmg")),
            new Array("","+ <font color='#FFFFFF'>0.012</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.003</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.0018%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.006</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.003</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.003%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.006%</font> "+$.Localize("#relicmagdmg")),
            new Array("","+ <font color='#FFFFFF'>0.014</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.0035</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.0021%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.007</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.0035</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.0035%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.007%</font> "+$.Localize("#relicmagdmg")),
            new Array("","+ <font color='#FFFFFF'>0.016</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.004</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.0024%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.008</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.004</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.004%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.008%</font> "+$.Localize("#relicmagdmg")),
            new Array("","+ <font color='#FFFFFF'>0.018</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.0045</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.0027%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.009</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.0045</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.0045%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.009%</font> "+$.Localize("#relicmagdmg")),
            new Array("","+ <font color='#FFFFFF'>0.02</font> "+$.Localize("#relicdmg"),"+ <font color='#FFFFFF'>0.005</font> "+$.Localize("#relicarmor"),"+ <font color='#FFFFFF'>0.003%</font> "+$.Localize("#relicmagres"),"+ <font color='#FFFFFF'>0.01</font> "+$.Localize("#relicattackspeed"),"+ <font color='#FFFFFF'>0.005</font> "+$.Localize("#relicallatr"),"+ <font color='#FFFFFF'>0.005%</font> "+$.Localize("#relicmagvamp"),"+ <font color='#FFFFFF'>0.01%</font> "+$.Localize("#relicmagdmg")))
    );
    if (num.charAt(3) != "0")
    {
        if (num.charAt(0) == "4")
        {
            $("#itemstat1").visible = true;
            $("#itemstat1").text = params[Number(num.charAt(0))][Number(num.charAt(7))][Number(num.charAt(3))];
        }
        else
        {
            $("#itemstat1").visible = true;
            $("#itemstat1").text = params[Number(num.charAt(0))][Number(num.charAt(3))];
        }
    }
    else
    {
        $("#itemstat1").visible = false;
    }
    if (num.charAt(4) != "0")
    {
        if (num.charAt(0) == "4")
        {
            $("#itemstat2").visible = true;
            $("#itemstat2").text = params[Number(num.charAt(0))][Number(num.charAt(7))][Number(num.charAt(4))];
        }
        else
        {
            $("#itemstat2").visible = true;
            $("#itemstat2").text = params[Number(num.charAt(0))][Number(num.charAt(4))];
        }
    }
    else
    {
        $("#itemstat2").visible = false;
    }
    $("#itemname").text = "<font color='"+rarecolor+"'>"+elem+" "+rares+"</font>";
    $("#itemrare").text = $.Localize("#rsrareness") + " " + rare;
    $("#iteminslot").visible = false;
    if (num.charAt(num.length-1) == "t")
    {
        $("#iteminslot").visible = true;
    }
    $("#itemdiscr").visible = false;
    if (num.charAt(5)+num.charAt(6) != "00")
    {
        $("#itemdiscr").visible = true;
        $("#itemdiscr").text = $.Localize("#rsdiscr"+num.charAt(5)+num.charAt(6));
    }
    $("#star1").visible = false;
    $("#star2").visible = false;
    $("#star3").visible = false;
    $("#star4").visible = false;
    $("#star5").visible = false;
    if (num.charAt(7) != "0")
    {
        for (var i = 1;Number(num.charAt(7)) >= i;i++)
        {
            $("#star"+i).visible = true;
        }
    }
}

