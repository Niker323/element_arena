print ('[BAREBONES] barebones.lua' )

-- GameRules Variables
ENABLE_HERO_RESPAWN = false              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = true             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = false        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 60.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 10.0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 30.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 0                       -- How much gold should players get per tick?
GOLD_TICK_TIME = 999999.0                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
-- CAMERA_DISTANCE_OVERRIDE = 1134.0        -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                    -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = true      -- Should we disable fog of war entirely for both teams?
USE_STANDARD_HERO_GOLD_BOUNTY = false    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false  -- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = true       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 200                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

ELEMENTS_CREATED = false

PlaysTopList = {}
WinsTopList = {}
HardWinsTopList = {}
MyProfileArray = {}
_G.bonuses = {}
_G.bonuses[1] = {}
_G.bonuses[2] = {}
_G.bonuses[3] = {}
_G.bonuses[4] = {}
_G.bonuses[5] = {}
_G.bonuses[6] = {}
_G.bonuses[7] = {}
_G.defaultpart = {}

_G.patreons = {}

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 100
end

-- Generated from template
if GameMode == nil then
	print ( '[BAREBONES] creating barebones game mode' )
	GameMode = class({})
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	print('[BAREBONES] Starting to load Barebones gamemode...')

	-- Setup rules
	GameRules:SetShowcaseTime( 0.0 )
    GameRules:GetGameModeEntity():SetAnnouncerDisabled( false )
 	GameRules:GetGameModeEntity():DisableHudFlip( true )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetHeroSelectPenaltyTime( 0 )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
    --GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 6 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled( false )
	GameRules:EnableCustomGameSetupAutoLaunch(true)
    GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    
    SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
    
	print('[BAREBONES] GameRules set')

	-- Listeners - Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
	ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
	ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
	-- ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
	ListenToGameEvent('player_stats_updated', Dynamic_Wrap(GameMode, 'OnPSUpdated'), self)
    
	CustomGameEventManager:RegisterListener("Vote_Round", Dynamic_Wrap(GameMode, 'Vote_Round'))
	CustomGameEventManager:RegisterListener("Buy_Relic", Dynamic_Wrap(GameMode, 'Buy_Relic'))
	CustomGameEventManager:RegisterListener("UpdateTops", Dynamic_Wrap(GameMode, 'UpdateTops'))
	CustomGameEventManager:RegisterListener("Levels", Dynamic_Wrap(GameMode, 'Levels'))
	CustomGameEventManager:RegisterListener("SelectPart", Dynamic_Wrap(GameMode, 'SelectPart'))
	CustomGameEventManager:RegisterListener("ToggleAutoVote", Dynamic_Wrap(GameMode, 'ToggleAutoVote'))
	CustomGameEventManager:RegisterListener("RefreshRelics", Dynamic_Wrap(GameMode, 'LoadRelics'))
	CustomGameEventManager:RegisterListener("Buy_Element", Dynamic_Wrap(GameMode, 'Buy_Element'))
	CustomGameEventManager:RegisterListener("UpdateProfiles", Dynamic_Wrap(GameMode, 'UpdateProfiles'))
	CustomGameEventManager:RegisterListener("SniatRS", Dynamic_Wrap(GameMode, 'SniatRS'))
	CustomGameEventManager:RegisterListener("EqipRS", Dynamic_Wrap(GameMode, 'EqipRS'))
	CustomGameEventManager:RegisterListener("PureRS", Dynamic_Wrap(GameMode, 'PureRS'))
	CustomGameEventManager:RegisterListener("SetDefaultPart", Dynamic_Wrap(GameMode, 'SetDefaultPart'))
	CustomGameEventManager:RegisterListener("SaveSet", Dynamic_Wrap(GameMode, 'SaveSet'))
	CustomGameEventManager:RegisterListener("LoadSet", Dynamic_Wrap(GameMode, 'LoadSet'))
	CustomGameEventManager:RegisterListener("SetColor", Dynamic_Wrap(GameMode, 'SetColor'))
	CustomGameEventManager:RegisterListener("UpgradeRS", Dynamic_Wrap(GameMode, 'UpgradeRS'))
	CustomGameEventManager:RegisterListener("OnLoadPlayerVote", Dynamic_Wrap(GameMode, 'OnLoadPlayerVote'))
    
    --GameRules:GetGameModeEntity():SetCustomTerrainWeatherEffect( "particles/rain_fx/econ_snow.vpcf" )
    GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( GameMode, "ItemAddedToInventoryFilter" ), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( GameMode, "ExecuteOrderFilter" ), self )
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap( GameMode, "DamageFilter" ), self)
    GameRules:GetGameModeEntity():SetHudCombatEventsDisabled(true)
    
	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))
    GameMode:GetNum("http://")
    CustomNetTables:SetTableValue("Hero_Stats","wave",{0})
    for i=0,4 do
        local tbl = {
            tdmg = 0,
            heal = 0,
            last = 0,
            ddmg = 0
        }
        CustomNetTables:SetTableValue("Hero_Stats",tostring(i),tbl)
    end

	-- Initialized tables for tracking state
	self.vUserIds = {}
	self.vSteamIds = {}
	self.vBroadcasters = {}

	self.vPlayers = {}
    
    _G.hardmode = false
    _G.userelic = false
    _G.wave_effect_mods = {}
    _G.portal_items = {}
    _G.portal_item_drops = {}

    _G.DedicatedServerKey = GetDedicatedServerKeyV2("2")
    
    if GetMapName() == "hard" then
        GameRules.DropTable = LoadKeyValues("scripts/kv/hard_item_drops.kv")
        _G.hardmode = true
    else
        GameRules.DropTable = LoadKeyValues("scripts/kv/item_drops.kv")
    end
    
	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "test_command", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", 0 )
	Convars:RegisterCommand( "vote", Dynamic_Wrap(GameMode, 'MyConsVote'), "A console command example", 0 )
	Convars:RegisterCommand( "disitems", Dynamic_Wrap(GameMode, 'DisNoobsItems'), "A console command example", 0 )
	Convars:RegisterCommand( "getrelicstones", Dynamic_Wrap(GameMode, 'GetRelicStones'), "A console command example", 0 )
    Convars:RegisterCommand( "getfullrelic", Dynamic_Wrap(GameMode, 'GetFullRelic'), "A console command example", 0 )
    Convars:RegisterCommand( "lasttest", Dynamic_Wrap(GameMode, 'TestLastBoss'), "A console command example", 0 )
    -- Convars:RegisterCommand( "startarena", Dynamic_Wrap(GameMode, 'StartShadowArena'), "A console command example", 0 )
    Convars:RegisterCommand( "check_key", Dynamic_Wrap(GameMode, 'CheckKey'), "A console command example", 0 )
    Convars:RegisterCommand( "teleport_to_zone", Dynamic_Wrap(GameMode, 'TeleportToZoneCommand'), "A console command example", 0 )
    Convars:RegisterCommand( "test_select", Dynamic_Wrap(GameMode, 'TestSelect'), "A console command example", 0 )
    
    GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )

    Pets:Init()

	print('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function GameMode:CheckKey(keyid)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if keyid ~= nil then
			CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = GetDedicatedServerKeyV2(keyid) })
        end
	end
end

function GameMode:TestSelect()
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        cmdPlayer:SetSelectedHero("npc_dota_hero_snapfire")
	end
end

function GameMode:ToggleAutoVote(event)
    if event == nil or event.PlayerID == nil then return end
    PlayerResource:GetSelectedHeroEntity(event.PlayerID).autovote = event.state
end

function GameMode:Buy_Relic(event)
    _G.userelic = true
    if event == nil or event.PlayerID == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    if hero.relicboolarr ~= nil then
        if event.num == 0 then
            local item_list = {
                "item_corrupting_blade",
                "item_glimmerdark_shield",
                "item_guardian_shell",
                "item_dredged_trident",
                "item_oblivions_locket",
                "item_ambient_sorcery",
                "item_wand_of_the_brine",
                "item_seal_0"
            }
            for i=1,8 do
                if hero.relicboolarr[i] == true and IsFreeSpaceInInventory(hero) then
                    local itemname = item_list[i]
                    if itemname == "item_seal_0" then
                        if hero.actseal == true then
                            itemname = "item_seal_act_r"
                        end
                    end
                    local item = CreateItem(itemname, hero, hero)
                    item:SetPurchaseTime(0)
                    item:SetPurchaser( hero )
                    item.bIsRelic = true
                    hero:AddItem(item)
                    hero.relicboolarr[i] = false
                end
            end
        else
            if hero.relicboolarr[event.num] == true and IsFreeSpaceInInventory(hero) then
                local itemname = event.item
                if itemname == "item_seal_0" then
                    if hero.actseal == true then
                        itemname = "item_seal_act_r"
                    end
                end
                local item = CreateItem(itemname, hero, hero)
                item:SetPurchaseTime(0)
                item:SetPurchaser( hero )
                item.bIsRelic = true
                EmitSoundOn( "General.Buy", hero )
                hero:AddItem(item)
                hero.relicboolarr[event.num] = false
            end
        end
    end
end

function GameMode:Buy_Element(event)
    if event == nil or event.PlayerID == nil then return end
    local myTable = CustomNetTables:GetTableValue("Elements_Tabel",tostring(event.PlayerID))
    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    if myTable ~= nil and myTable[tostring(event.num)] ~= nil and myTable[tostring(event.num)] > 0 and hero and IsFreeSpaceInInventory(hero) then
        myTable[tostring(event.num)] = myTable[tostring(event.num)] - 1
        CustomNetTables:SetTableValue("Elements_Tabel",tostring(event.PlayerID),myTable)
        local itemname = allelements[event.num]
        local item = CreateItem(itemname, hero, hero)
        item:SetPurchaseTime(0)
        item:SetPurchaser( hero )
        EmitSoundOn( "General.Buy", hero )
        hero:AddItem(item)
    end
end

function GameMode:SniatRS(event)
    if event == nil or event.PlayerID == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    hero.rsslots[event.slotid] = ""
    local data = {}
    data.PlayerID = event.PlayerID
    GameMode:UpdateRS(event.PlayerID)
    GameMode:Levels(data)
end

function GameMode:EqipRS(event)
    if event == nil or event.PlayerID == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    local eqiped = false
    for i=1,8 do
        if hero.rsslots[i] == event.rsid then
            eqiped = true
            break
        end
    end
    if eqiped == false then
        local find = false
        if hero.seal == true then
            for i=1,4 do
                if hero.rsslots[i] == "" then
                    hero.rsslots[i] = event.rsid
                    find = true
                    break
                end
            end
            if find == false then
                if hero.actseal == true then
                    for i=5,8 do
                        if hero.rsslots[i] == "" then
                            hero.rsslots[i] = event.rsid
                            --print(hero.rsslots[i])
                            find = true
                            break
                        end
                    end
                end
            end
        end
        --if find == true then
        --    GameMode:Levels(event)
        --end
    end
    GameMode:UpdateRS(event.PlayerID)
    GameMode:Levels(event)
end

puretimerok = true
function GameMode:PureRS(event)
    if event == nil or event.PlayerID == nil then return end
    if puretimerok == true then
        puretimerok = false
        Timers:CreateTimer(5, function()
            puretimerok = true
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(event.PlayerID), "PureButtonReady", {})
        end)
        local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
        local pureok = false
        local inslot = false
        local newlist = {}
        local rspure = 0
        for k,v in pairs(event.rs) do
            for i=1,8 do
                if hero.rsslots[i] == v then
                    inslot = true
                    break
                end
            end
            for i=1,#hero.rsinv do
                if hero.rsinv[i] == v then
                    if inslot == false then
                        table.remove(hero.rsinv,i)
                        pureok = true
                    end
                    break
                end
            end
            if pureok then
                table.insert(newlist,v)
                local fchr = string.sub(v, 1, 1)
                if fchr == "1" then rspure = rspure + 1
                elseif fchr == "2" then rspure = rspure + 3
                elseif fchr == "3" then rspure = rspure + 15
                elseif fchr == "4" then rspure = rspure + 60
                end
            end
        end
        hero.rsp = hero.rsp + rspure
        if #newlist > 0 then
            local rstr = ""
            for i=1,#newlist do
                if rstr == "" then
                    rstr = rstr .. newlist[i]
                else
                    rstr = rstr .. "|" .. newlist[i]
                end
            end
            --print(rstr)
            local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/relicstones1.php")
            req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(event.PlayerID)))
            req:SetHTTPRequestGetOrPostParameter("rsids", rstr)
            req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
            req:Send(function(result)
                print(result.Body)
            end)
        end
        GameMode:UpdateRS(event.PlayerID)
        GameMode:Levels(event)
    end
end

function GameMode:SetDefaultPart(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
    if player.parttimerok == nil then player.parttimerok = true end
    if player.parttimerok == true then
        player.parttimerok = false
        Timers:CreateTimer(30, function()
            player.parttimerok = true
            CustomGameEventManager:Send_ServerToPlayer( player, "DefaultButtonReady", {})
        end)
        local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/data.php")
        req:SetHTTPRequestGetOrPostParameter("inid", tostring(PlayerResource:GetSteamID(event.PlayerID)))
        req:SetHTTPRequestGetOrPostParameter("part", "defaults")
        req:SetHTTPRequestGetOrPostParameter("reson", tostring(event.part))
        req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
        req:Send(function(result)
            print(result.Body)
        end)
    end
end

function GameMode:SaveSet(event)
    if event == nil or event.PlayerID == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    if hero == nil or hero.rsslots == nil then return end
    if hero.sevesettimerok == nil then hero.sevesettimerok = true end
    if hero.sevesettimerok == true then
        hero.sevesettimerok = false
        Timers:CreateTimer(5, function()
            hero.sevesettimerok = true
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(event.PlayerID), "ReadySetButton", {})
        end)
        local rstr = ""
        for i=1,8 do
            if i ~= 8 then
                rstr = rstr .. hero.rsslots[i] .. "|"
            else
                rstr = rstr .. hero.rsslots[i]
            end
        end
        if hero.rssaves == nil then
            hero.rssaves = {}
        end
        hero.rssaves[tonumber(event.num)] = rstr
        local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/relicstones1.php")
        req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(event.PlayerID)))
        req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
        req:SetHTTPRequestGetOrPostParameter("savenum", tostring(event.num))
        req:SetHTTPRequestGetOrPostParameter("slots", rstr)
        req:Send(function(result)
            print(result.Body)
        end)
        GameMode:UpdateRS(event.PlayerID)
        GameMode:Levels(event)
    end
end

function GameMode:UpgradeRS(event)
    if event == nil or event.PlayerID == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    for i=1,#hero.rsinv do
        if hero.rsinv[i] == event.rs then
            local rares = string.sub(event.rs, 1, 1)
            local qual = string.sub(event.rs, 8, 8)
            if qual ~= "5" and rares == "4" then
                local cost = 0
                if     qual == "0" then cost = 40
                elseif qual == "1" then cost = 80
                elseif qual == "2" then cost = 160
                elseif qual == "3" then cost = 320
                elseif qual == "4" then cost = 640
                end
                if hero.rsp ~= nil and hero.rsp >= cost then
                    hero.rsinv[i] = string.sub(event.rs, 1, 7) .. tonumber(qual)+1 .. string.sub(event.rs, 9)
                    hero.rsp = hero.rsp - cost
                    local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/relicstones1.php")
                    req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(event.PlayerID)))
                    req:SetHTTPRequestGetOrPostParameter("uprsid", event.rs)
                    req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
                    req:Send(function(result)
                        print(result.Body)
                    end)
                end
            end
            GameMode:Levels(event)
            break
        end
    end
end

function GameMode:SetColor(event)
    if event == nil or event.PlayerID == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    if event.colorid ~= 1 then
        for i=1,#hero.sealcolors do
            if hero.sealcolors[i] == event.colorid then
                hero.sealcolor = event.colorid
                break
            end
        end
    else
        hero.sealcolor = event.colorid
    end
    --print(hero.sealcolor)
end

function GameMode:LoadSet(event)
    if event == nil or event.PlayerID == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
    if hero == nil or hero.rsinv == nil or hero.rssaves == nil then return end
    local thisslots = {}
    hero.rsslots = {"","","","","","","",""}
    for token in string.gmatch(hero.rssaves[tonumber(event.num)].."|", "([^|]*)|") do
        local moshnoadd = true
        local estininv = false
        for i=1,#hero.rsinv do
            if hero.rsinv[i] == token then
                estininv = true
                break
            end
        end
        for i=1,8 do
            if hero.rsslots[i] == token then
                moshnoadd = false
                break
            end
        end
        if moshnoadd == true and estininv == true then
            table.insert(thisslots,token)
        else
            table.insert(thisslots,"")
        end
    end
    if #thisslots == 8 then
        hero.rsslots = thisslots
    end
    GameMode:UpdateRS(event.PlayerID)
    GameMode:Levels(event)
end

for i=1,6 do
    if i<10 then
        LinkLuaModifier( "immortal_mod_0" .. i, "modifiers/immortal_mods", LUA_MODIFIER_MOTION_NONE )
    else
        LinkLuaModifier( "immortal_mod_" .. i, "modifiers/immortal_mods", LUA_MODIFIER_MOTION_NONE )
    end
end

function GameMode:UpdateRS(id)
    if id == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(id)
    _G.bonuses[1][id] = 0
    _G.bonuses[2][id] = 0
    _G.bonuses[3][id] = 0
    _G.bonuses[4][id] = 0
    _G.bonuses[5][id] = 0
    _G.bonuses[6][id] = 0
    _G.bonuses[7][id] = 0
    local colors = {}
    --print("StartLoad")
    for i=1,8 do
        if hero.immortalbuffs[i] ~= nil then
            hero:RemoveModifierByName(hero.immortalbuffs[i])
            hero.immortalbuffs[i] = nil
        end
        if hero.rsslots[i] ~= "" then
            table.insert(colors,tonumber(string.sub(hero.rsslots[i], 2, 2))+2)
            local lclarr = {
                {0.005,0.0015,0.001,0.0025,0.0015,0.0015,0.0025},
                {0.01,0.0025,0.0015,0.005,0.0025,0.0025,0.005},
                {0.01,0.0025,0.0015,0.005,0.0025,0.0025,0.005},
                {
                    {0.01,0.0025,0.0015,0.005,0.0025,0.0025,0.005},
                    {0.012,0.003,0.0018,0.006,0.003,0.003,0.006},
                    {0.014,0.0035,0.0021,0.007,0.0035,0.0035,0.007},
                    {0.016,0.004,0.0024,0.008,0.004,0.004,0.008},
                    {0.018,0.0045,0.0027,0.009,0.0045,0.0045,0.009},
                    {0.02,0.005,0.003,0.01,0.005,0.005,0.01}
                }
            }
            if string.sub(hero.rsslots[i], 4, 4) ~= "0" then
                local relicid = tonumber(string.sub(hero.rsslots[i], 4, 4))
                if relicid ~= 0 then
                    if string.sub(hero.rsslots[i], 1, 1) == "4" then
                        _G.bonuses[relicid][id] = _G.bonuses[relicid][id] + lclarr[tonumber(string.sub(hero.rsslots[i], 1, 1))][tonumber(string.sub(hero.rsslots[i], 8, 8))+1][relicid]
                    else
                        _G.bonuses[relicid][id] = _G.bonuses[relicid][id] + lclarr[tonumber(string.sub(hero.rsslots[i], 1, 1))][relicid]
                    end
                end
            end
            if string.sub(hero.rsslots[i], 5, 5) ~= "0" then
                local relicid = tonumber(string.sub(hero.rsslots[i], 5, 5))
                if relicid ~= 0 then
                    if string.sub(hero.rsslots[i], 1, 1) == "4" then
                        _G.bonuses[relicid][id] = _G.bonuses[relicid][id] + lclarr[tonumber(string.sub(hero.rsslots[i], 1, 1))][tonumber(string.sub(hero.rsslots[i], 8, 8))+1][relicid]
                    else
                        _G.bonuses[relicid][id] = _G.bonuses[relicid][id] + lclarr[tonumber(string.sub(hero.rsslots[i], 1, 1))][relicid]
                    end
                end
            end
            if string.sub(hero.rsslots[i], 6, 7) ~= "00" then
                --print("immortal_mod_" .. string.sub(hero.rsslots[i], 6, 7))
                hero:AddNewModifier(hero, nil, "immortal_mod_" .. string.sub(hero.rsslots[i], 6, 7), {})
                hero.immortalbuffs[i] = "immortal_mod_" .. string.sub(hero.rsslots[i], 6, 7)
            end
        end
    end
    local estcolor = false
    for i=1,#colors do
        if colors[i] == hero.sealcolor then
            estcolor = true
        end
    end
    if estcolor == false then
        hero.sealcolor = 1
    end
    if _G.patreons[tostring(PlayerResource:GetSteamID(id))] ~= nil then
        if _G.patreons[tostring(PlayerResource:GetSteamID(id))] > 2 then
            table.insert(colors,12)
        end
    end
    hero.sealcolors = colors
    local modifs = hero:FindAllModifiers()
    for b=1, #modifs do
        if modifs[b]:GetAbility() ~= nil then
            if modifs[b].needupwawe then
                modifs[b]:OnWaweChange(_G.GAME_ROUND)
            end
        end
    end
end

function GameMode:OnThink()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:_CheckForDefeat()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end
	return 1
end

function GameMode:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end

	local bAllPlayersDead = true
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hero and hero:IsAlive() then
					bAllPlayersDead = false
				end
			end
		end
	end

    if bAllPlayersDead then
        if _G.shadow_arena then
            GameMode:StopShadowArena(false)
        else
            local plc = PlayerResource:GetPlayerCount()
            for i=0,plc-1 do
                local hero = PlayerResource:GetSelectedHeroEntity(i)
                local sch = 0
                if hero ~= nil then
                    sch = hero.damage_schetchik or 0
                end
                local tbl = {
                    tdmg = PlayerResource:GetCreepDamageTaken(i,true),
                    heal = PlayerResource:GetHealing(i),
                    last = PlayerResource:GetLastHits(i),
                    ddmg = math.ceil(sch)
                }
                CustomNetTables:SetTableValue("Hero_Stats",tostring(i),tbl)
            end
            GameMode:_Stats(nil)
            GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
            -- return
        end
	end
end

mode = nil

-- This function is called 1 to 2 times as the player connects initially but before they
-- have completely connected
function GameMode:PlayerConnect(keys)
	print('[BAREBONES] PlayerConnect')
	DeepPrintTable(keys)
    
    --Timers:RemoveTimer("disconnected" .. tostring(keys.userid))
    
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	print ('[BAREBONES] OnConnectFull')
	DeepPrintTable(keys)
	GameMode:CaptureGameMode()

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()

	-- Update the user ID table with this user
	self.vUserIds[keys.userid] = ply

	-- Update the Steam ID table
	self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply

	-- If the player is a broadcaster flag it in the Broadcasters table
	if PlayerResource:IsBroadcaster(playerID) then
		self.vBroadcasters[keys.userid] = 1
		return
	end
end

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:CaptureGameMode()
	if mode == nil then
		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		--mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		--mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )
        mode:SetLoseGoldOnDeath( false )
        
        mode:SetHUDVisible(1,true)
        mode:SetHUDVisible(4,false)
        mode:SetHUDVisible(9, false)
        
		self:OnFirstPlayerLoaded()
	end
end

-- This is an example console command
function GameMode:ExampleConsoleCommand(srt , int)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if srt ~= nil and int ~= nil then
            local item = CreateItem(srt, nil, nil)
            item:SetPurchaseTime(0)
            local pos = PlayerResource:GetSelectedHeroEntity(cmdPlayer:GetPlayerID()):GetAbsOrigin()
            local drop = CreateItemOnPositionSync( pos, item )
            item:SetPurchaser( PlayerResource:GetSelectedHeroEntity(tonumber(int)) )
        end
	end
end

function GameMode:GetRelicStones(rs)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if rs ~= nil then
            CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rs,hero = PlayerResource:GetSelectedHeroName(cmdPlayer:GetPlayerID())})
        else
            CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = "40143044164",hero = PlayerResource:GetSelectedHeroName(cmdPlayer:GetPlayerID())})
        end
	end
end

function GameMode:TestLastBoss()
	local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        PlayerResource:GetSelectedHeroEntity(cmdPlayer:GetPlayerID()):SetOrigin(Entities:FindByName( nil, "tp_point1"):GetAbsOrigin())
        ChangeWorldBounds(Vector(-16384, -16384, 8), Vector(16384, 16384, 8))
        SetCameraToPosForPlayer(cmdPlayer:GetPlayerID(),Entities:FindByName( nil, "tp_point1"):GetAbsOrigin())
        Timers:CreateTimer(2.5,function()
            ChangeWorldBounds(Vector(-2560, -11769.6, 8), Vector(2560, -5632, 8))
        end)
	end
end

function GameMode:TeleportToZoneCommand(zone)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if zone ~= nil then
            TeleportPlayerToZone(cmdPlayer:GetPlayerID(), zone)
        end
	end
end

function GameMode:StartShadowArena()
    if not _G.shadow_arena and GameMode:GetTimeToWave() ~= 0 then
        _G.shadow_arena = true
        
        -- if _G.portal_item_drop then UTIL_Remove( _G.portal_item_drop ) end
        -- if _G.portal_item then UTIL_Remove( _G.portal_item ) end

        QuestSystem:DelQuest("PrepTime")
        CustomGameEventManager:Send_ServerToAllClients( "Close_DamageTop", {})
        CustomGameEventManager:Send_ServerToAllClients( "Close_RoundVote", {})

        local center = Entities:FindByName( nil, "boss_zone_center"):GetAbsOrigin()

        RefreshPlayers()
        ChangeWorldBounds(Vector(-16384, -16384, 8), Vector(16384, 16384, 8))
        TeleportAllPlayersToZone("boss_zone")

        Timers:CreateTimer(2,function()
            ChangeWorldBounds(Vector(-2560, -11769.6, 8), Vector(2560, -5632, 8))
        end)

        local tiers = {
            {--tier1
                "npc_dota_custom_creep_1_1",
                "npc_dota_custom_creep_2_1",
                "npc_dota_custom_creep_2_2",
                "npc_dota_custom_creep_2_3",
                "npc_dota_custom_creep_6_2",
                "npc_dota_custom_creep_7_2",
                "npc_dota_custom_creep_8_2",
                "npc_dota_custom_creep_9_3",
                "npc_dota_custom_creep_11_1",
                "npc_dota_custom_creep_12_3",
                "npc_dota_custom_creep_14_1",
                "npc_dota_custom_creep_16_1",
                "npc_dota_custom_creep_17_2",
                "npc_dota_custom_creep_19_2",
                "npc_dota_custom_creep_21_1",
                "npc_dota_custom_creep_22_1",
                "npc_dota_custom_creep_23_2",
                "npc_dota_custom_creep_27_1",
                "npc_dota_custom_creep_28_1",
                "npc_dota_custom_creep_29_1",
                "npc_dota_custom_creep_31_4",
                "npc_dota_custom_creep_32_3",
                "npc_dota_custom_creep_33_2",
                "npc_dota_custom_creep_33_3",
                "npc_dota_custom_creep_34_1",
                "npc_dota_custom_creep_34_3",
                "npc_dota_custom_creep_38_2",
                "npc_dota_custom_creep_39_2",
            },
            {--tier2
                "npc_dota_custom_creep_3_1",
                "npc_dota_custom_creep_4_1",
                "npc_dota_custom_creep_6_1",
                "npc_dota_custom_creep_8_3",
                "npc_dota_custom_creep_12_1",
                "npc_dota_custom_creep_17_1",
                -- "npc_dota_custom_creep_18_2",
                "npc_dota_custom_creep_24_3",
                "npc_dota_custom_creep_26_1",
                -- "npc_dota_custom_creep_31_1",--crash
                "npc_dota_custom_creep_36_2",
                "npc_dota_custom_creep_37_2",
            },
            {--tier3
                "npc_dota_custom_creep_5_1",
                "npc_dota_custom_creep_9_1",
                "npc_dota_custom_creep_15_1",
                "npc_dota_custom_creep_20_1",
                "npc_dota_custom_creep_25_1",
                "npc_dota_custom_creep_30_1",
                "npc_dota_custom_creep_35_1",
            },
            {--tier4
                "npc_dota_custom_creep_40_1"
            },
        }--next 41

        _G.shadow_arena_spawning = true
        local unit_cols_per_wave = {
            15,--tier1
            8,--tier2
            1,--tier3
            0,--tier4
        }
        local summ = 0
        for i=1,#unit_cols_per_wave do
            summ = summ + unit_cols_per_wave[i]
        end
        local waves = 4
        Timers:CreateTimer(10,function()
            if _G.shadow_arena_spawning then
                for i=0,waves-1 do
                    local unitnum = 0
                    Timers:CreateTimer(25*i,function()
                        if _G.shadow_arena_spawning then
                            local nowtier = 0
                            local locunitnum = unitnum
                            for x=1,#unit_cols_per_wave do
                                if locunitnum < unit_cols_per_wave[x] then
                                    nowtier = x
                                    break
                                else
                                    locunitnum = locunitnum - unit_cols_per_wave[x]
                                end
                            end
                            -- print("Spawn_"..i.."_"..nowtier.."_"..unitnum)
                            local unit = CreateUnitByName( tiers[nowtier][RandomInt(1,#tiers[nowtier])], center + RandomVector( 2500 ), true, nil, nil, DOTA_TEAM_BADGUYS )
                            unit:RemoveAbility("my_boss_hpdar")
                            unit:RemoveModifierByName("my_boss_hpdar_mod")
                            unit:SetAcquisitionRange(999999)
                            unit.tier = nowtier
                            unitnum = unitnum + 1
                            if unitnum < summ then
                                return 0.7
                            else
                                if i == waves-1 then
                                    _G.shadow_arena_spawning = false
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
end

function GameMode:StopShadowArena(win)
    -- print("StopShadowArena 1")
    if not _G.shadow_arena_endphase then
        -- print("StopShadowArena 2")
        _G.shadow_arena_endphase = true
        _G.shadow_arena_spawning = false
        local center_ent = Entities:FindByName( nil, "boss_zone_center")
        local creeps = FindUnitsInRadius(
            DOTA_TEAM_BADGUYS,
            center_ent:GetAbsOrigin(),
            nil,
            3600,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false
        )
        print(#creeps)
        for i=1,#creeps do
            creeps[i]:Stop()
            UTIL_Remove(creeps[i])
            -- creeps[i]:ForceKill(false)
        end
        RefreshPlayers()

        function center_ent:GetUnitName()
            return "end_shadow_arena"
        end
        -- print(center_ent:GetUnitName())
        -- print(center_ent:GetAbsOrigin())
        local time_to_teleport = 5
        if win then
            RollDrops(center_ent)
            time_to_teleport = 20
            local real_heroes = GetAllRealHeroes()
            for i=1,#real_heroes do
                local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_ABSORIGIN_FOLLOW, real_heroes[i] )
                ParticleManager:ReleaseParticleIndex( pfx )
            end
        end

        Timers:CreateTimer(time_to_teleport,function()
            local plc = PlayerResource:GetPlayerCount()
            ChangeWorldBounds(Vector(-16384, -16384, 8), Vector(16384, 16384, 8))
            for i=0,plc-1 do
                local hero = PlayerResource:GetSelectedHeroEntity(i)
                hero:Stop()
                hero:RemoveModifierByName("modifier_item_mystery_cyclone_active")
                local pfx1 = ParticleManager:CreateParticle( "particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", PATTACH_ABSORIGIN, hero )
                ParticleManager:ReleaseParticleIndex( pfx1 )
                FindClearSpaceForUnit(hero, Entities:FindByName( nil, "point"..(i+1)):GetAbsOrigin(), true )
                local pfx2 = ParticleManager:CreateParticle( "particles/econ/events/ti4/blink_dagger_end_ti4.vpcf", PATTACH_ABSORIGIN, hero )
                ParticleManager:ReleaseParticleIndex( pfx2 )
                SetCameraToPosForPlayer(i,Entities:FindByName( nil, "point3"):GetAbsOrigin())
            end

            Timers:CreateTimer(2,function()
                ChangeWorldBounds(Vector(-256, -2048, 8), Vector(256, 1024, 8))
            end)
            _G.shadow_arena = false
            GameMode:OnGameInProgress()
            _G.shadow_arena_endphase = false
        end)
    end
end

function GameMode:GetFullRelic(strid)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if strid ~= nil then
            local id = tonumber(strid)
            local hero = PlayerResource:GetSelectedHeroEntity(id)
            hero.lvl_item_corrupting_blade = 20
            hero.lvl_item_glimmerdark_shield = 20
            hero.lvl_item_guardian_shell = 20
            hero.lvl_item_dredged_trident = 20
            hero.lvl_item_oblivions_locket = 20
            hero.lvl_item_ambient_sorcery = 20
            hero.lvl_item_wand_of_the_brine = 20
            hero.lvl_item_seal_0 = 1
            hero.rsinv = ""
            hero.rsp = 0
            hero.rsslots = ""
            hero.rssaves = ""
            
            local relicboolarr = {
                true,
                true,
                true,
                true,
                true,
                true,
                true,
                true
            }
            hero.seal = true
            hero.actseal = true
            hero.relicboolarr = relicboolarr
            local data = {}
            data.PlayerID = id
            GameMode:Levels(data)
        end
	end
end

LinkLuaModifier( "disab", "modifiers/disab", LUA_MODIFIER_MOTION_NONE )
function GameMode:DisNoobsItems(int)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if int ~= nil then
            local hero = PlayerResource:GetSelectedHeroEntity(tonumber(int))
            hero:AddNewModifier(hero, nil, "disab", {duration = 10})
            for i=0, 15, 1 do
                local current_item = hero:GetItemInSlot(i)
                if current_item ~= nil then
                    hero:DropItemAtPositionImmediate( current_item, hero:GetAbsOrigin() )
                end
            end
        end
	end
end

function GameMode:MyConsVote(int)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if int ~= nil then
            local eve = {
            PlayerID = tonumber(int)
            }
            GameMode:Vote_Round(eve)
        end
	end
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
	print("[BAREBONES] First Player has loaded")
end

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	print('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
	DeepPrintTable(keys)
    
	--local name = keys.name
	--local networkid = keys.networkid
	--local reason = keys.reason
	--local userid = keys.userid
    
    --[[
    Timers:CreateTimer("disconnected" .. tostring(userid), {
	useGameTime = true,
    endTime = 30,
    callback = function()
        local hero = PlayerResource:GetSelectedHeroEntity(userid-1)
        for i=0, 15, 1 do
            local current_item = hero:GetItemInSlot(i)
            if current_item ~= nil then
                hero:DropItemAtPositionImmediate( current_item, hero:GetAbsOrigin() )
            end
        end
    end})
    ]]
    
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	print("[BAREBONES] GameRules State Changed")
	DeepPrintTable(keys)

	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		for i = 0, PlayerResource:GetPlayerCount()-1 do
			PlayerResource:SetCustomTeamAssignment(i, DOTA_TEAM_GOODGUYS)
		end
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
            
    --###########################################################################################################################################################
            
        print("Load Patreons")
        local patreonreq = CreateHTTPRequestScriptVM( "GET", "https://pastebin.com/raw/Njy7mF0F")
        patreonreq:Send(function(result)
            --print(result.Body)
            for token in string.gmatch(result.Body, "([^|]*)|") do
                --print(token)
                local id = ""
                local lvl = ""
                id, lvl = token:match("([^,]+),([^,]+)")
                _G.patreons[id] = tonumber(lvl)
            end
            --print("Patreons Loaded")
            --DeepPrintTable(_G.patreons)
            local pplc = PlayerResource:GetPlayerCount()
            for i=0,pplc-1 do
                local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(i))
                --print(parts)
                if parts ~= nil then
                    --patreon particles
                    parts["11"] = "nill"
                    parts["12"] = "nill"
                    parts["13"] = "nill"
                    parts["14"] = "nill"
                    parts["15"] = "nill"
                    local plvl = _G.patreons[tostring(PlayerResource:GetSteamID(i))]
                    if plvl ~= nil then
                        if plvl >= 1 then
                            parts["7"] = "normal"
                            parts["11"] = "normal"
                        end
                        if plvl >= 2 then
                            parts["12"] = "normal"
                        end
                        if plvl >= 3 then
                            parts["13"] = "normal"
                        end
                        if plvl >= 4 then
                            parts["14"] = "normal"
                        end
                        if plvl >= 5 then
                            parts["15"] = "normal"
                        end
                    end
                    -- DeepPrintTable(parts)
                    CustomNetTables:SetTableValue("Particles_Tabel",tostring(i),parts)
                else
                    parts = {}
                    --patreon particles
                    parts["11"] = "nill"
                    parts["12"] = "nill"
                    parts["13"] = "nill"
                    parts["14"] = "nill"
                    parts["15"] = "nill"
                    local plvl = _G.patreons[tostring(PlayerResource:GetSteamID(i))]
                    if plvl ~= nil then
                        if plvl >= 1 then
                            parts["7"] = "normal"
                            parts["11"] = "normal"
                        end
                        if plvl >= 2 then
                            parts["12"] = "normal"
                        end
                        if plvl >= 3 then
                            parts["13"] = "normal"
                        end
                        if plvl >= 4 then
                            parts["14"] = "normal"
                        end
                        if plvl >= 5 then
                            parts["15"] = "normal"
                        end
                    end
                    -- DeepPrintTable(parts)
                    CustomNetTables:SetTableValue("Particles_Tabel",tostring(i),parts)
                end
            end
        end)
            
    --###########################################################################################################################################################
        
        local req12 = CreateHTTPRequestScriptVM( "GET", GameMode.gjfll2 .. "/cache/tops.cache")
        -- req12:SetHTTPRequestGetOrPostParameter("v", "3")
        req12:Send(function(result)
            local otvwins = result.Body
            print(otvwins)
            if otvwins ~= "" then
                if otvwins ~= "none" then
                    local i = 1
                    local tops = {}
                    for token in string.gmatch(otvwins.."&", "([^&]*)&") do
                        tops[i] = token
                        i = i + 1
                    end
                    --DeepPrintTable(tops)
                    if tops[4] == "allok" then
                        local arr = {}
                        for token in string.gmatch(tops[1].." ", "([^ ]*) ") do
                            table.insert(arr,token)
                        end
                        GameMode:OnLoadTop(arr,1)
                        arr = {}
                        for token in string.gmatch(tops[2].." ", "([^ ]*) ") do
                            table.insert(arr,token)
                        end
                        GameMode:OnLoadTop(arr,2)
                        arr = {}
                        for token in string.gmatch(tops[3].." ", "([^ ]*) ") do
                            table.insert(arr,token)
                        end
                        GameMode:OnLoadTop(arr,3)
                    end
                end
            end
        end)
        
    --###########################################################################################################################################################
        
    local pplc = PlayerResource:GetPlayerCount()
    local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/data.php")
    for i=0,pplc-1 do
        req:SetHTTPRequestGetOrPostParameter("id"..(i+1), tostring(PlayerResource:GetSteamID(i)))
    end
    req:SetHTTPRequestGetOrPostParameter("v", "12")
    req:Send(function(result)
        local potv = result.Body
        print(potv)
        if potv ~= "" then
            --print(potv)
            local i = 0
            for token in string.gmatch(result.Body, "([^&]*)&") do
                --print(token)
                
                local particlesdata = ""
                local profiledata = ""
                profiledata, particlesdata = token:match("([^?]+)?([^?]+)")
                --print(particlesdata)
                --print(profiledata)

                local locstr = ""
                local arrstr = {}
                for n=1, string.len(particlesdata) do
                    if string.char(string.byte(particlesdata, n)) ~= nil then
                        if string.char(string.byte(particlesdata, n)) == "|" then
                            table.insert(arrstr, locstr)
                            locstr = ""
                        else
                            locstr = locstr .. string.char(string.byte(particlesdata, n))
                        end
                    end
                end
                if locstr ~= "" then
                    table.insert(arrstr, locstr)
                    locstr = ""
                end
                if arrstr[#arrstr] == "allok" then
                    arrstr[#arrstr] = nil
                    _G.defaultpart[i] = arrstr[#arrstr]
                    arrstr[#arrstr] = nil

                    --patreon particles
                    local plvl = _G.patreons[tostring(PlayerResource:GetSteamID(i))]
                    arrstr["11"] = "nill"
                    arrstr["12"] = "nill"
                    arrstr["13"] = "nill"
                    arrstr["14"] = "nill"
                    arrstr["15"] = "nill"
                    if plvl ~= nil then
                        if plvl >= 1 then
                            arrstr["7"] = "normal"
                            arrstr["11"] = "normal"
                        end
                        if plvl >= 2 then
                            arrstr["12"] = "normal"
                        end
                        if plvl >= 3 then
                            arrstr["13"] = "normal"
                        end
                        if plvl >= 4 then
                            arrstr["14"] = "normal"
                        end
                        if plvl >= 5 then
                            arrstr["15"] = "normal"
                        end
                    end
                    --DeepPrintTable(arrstr)
                    CustomNetTables:SetTableValue("Particles_Tabel",tostring(i),arrstr)
                end
                
                arrstr = {i}
                for n=1, string.len(profiledata) do
                    if string.char(string.byte(profiledata, n)) ~= nil then
                        if string.char(string.byte(profiledata, n)) == "|" then
                            table.insert(arrstr, locstr)
                            locstr = ""
                        else
                            locstr = locstr .. string.char(string.byte(profiledata, n))
                        end
                    end
                end
                if locstr ~= "" then
                    table.insert(arrstr, locstr)
                    locstr = ""
                end
                if arrstr[#arrstr] == "allok" then
                    arrstr[#arrstr] = nil
                    local value = arrstr
                    MyProfileArray[i] = value;
                    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "MyProfileInfo", value)
                end
                i = i + 1
            end
        end
    end)

    -- local req2 = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "mygamesonline.org/data.php")
    -- for i=0,pplc-1 do
    --     req2:SetHTTPRequestGetOrPostParameter("id"..(i+1), tostring(PlayerResource:GetSteamID(i)))
    -- end
    -- req2:SetHTTPRequestGetOrPostParameter("v", "1")
    -- req2:Send(function(result)
    --     local potv = result.Body
    --     --print(potv)
    --     if potv ~= "" then
    --         --print(potv)
    --         local i = 0
    --         for token in string.gmatch(result.Body, "([^&]*)&") do
    --             local locstr = ""
    --             local arrstr = {i}
    --             for n=1, string.len(token) do
    --                 if string.char(string.byte(token, n)) ~= nil then
    --                     if string.char(string.byte(token, n)) == "|" then
    --                         table.insert(arrstr, locstr)
    --                         locstr = ""
    --                     else
    --                         locstr = locstr .. string.char(string.byte(token, n))
    --                     end
    --                 end
    --             end
    --             if locstr ~= "" then
    --                 table.insert(arrstr, locstr)
    --                 locstr = ""
    --             end
    --             if arrstr[#arrstr] == "allok" then
    --                 arrstr[#arrstr] = nil
    --                 local value = arrstr
    --                 MyProfileArray[i] = value;
    --                 CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "MyProfileInfo", value)
    --             end
    --             i = i + 1
    --         end
    --     end
    -- end)
           
    --###########################################################################################################################################################
           
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameMode:OnGameInProgress()
        local pplc = PlayerResource:GetPlayerCount()
        for i=0,pplc-1 do
            local hero = PlayerResource:GetSelectedHeroEntity(i)
            if hero then
                if _G.defaultpart[i] ~= nil and _G.defaultpart[i] ~= "" and PlayerResource:GetConnectionState(i) == 2 then
                    if hero:FindModifierByName("part_mod") == nil then
                        local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(i))
                        if parts[_G.defaultpart[i]] ~= "nill" then
                            --Say(nil,"text here", false)
                            --GameRules:SendCustomMessage("<font color='#58ACFA'> использовал эффект </font>"..info.name.."#partnote".." test", 0, 0)
                            local arr = {
                                i,
                                PlayerResource:GetPlayerName(i),
                                _G.defaultpart[i],
                                PlayerResource:GetSelectedHeroName(i)
                            }
                    
                            -- local gameEvent = {}
                            -- gameEvent["player_id"] = i
                            -- gameEvent["teamnumber"] = -1
                            -- gameEvent["locstring_value"] = _G.defaultpart[i]--"#DOTA_Tooltip_Ability_" .. ability:GetAbilityName()
                            -- gameEvent["message"] = "#Combat_Message_use_ultimate"
                            -- FireGameEvent( "dota_combat_event_message", gameEvent )
                            CustomGameEventManager:Send_ServerToAllClients( "UpdateParticlesUI", arr)
                            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "SetSelectedParticles", arr)
                            hero:AddNewModifier(hero, hero, "part_mod", {part = _G.defaultpart[i]})
                        end
                    end
                end
                local plvl = _G.patreons[tostring(PlayerResource:GetSteamID(i))]
                if plvl ~= nil then
                    if plvl >= 1 then
                        hero:AddItemByName("item_purge_wave_effect")
                    end
                    if plvl >= 2 then
                        hero:AddItemByName("item_speed_wave_effect")
                    end
                    if plvl >= 3 then
                        hero:AddItemByName("item_regen_wave_effect")
                    end
                    if plvl >= 4 then
                        hero:AddItemByName("item_armor_wave_effect")
                    end
                    -- if plvl >= 5 then
                        
                    -- end
                end
            end
        end
	end
    
    if newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        local point = Entities:FindByName( nil, "spawner"):GetAbsOrigin()
        _G.gold_spirit = CreateUnitByName( "npc_dota_gold_spirit", point, true, nil, nil, DOTA_TEAM_GOODGUYS )
        for i=0, PlayerResource:GetPlayerCount()-1 do
            if PlayerResource:IsValidPlayerID(i) then
                if PlayerResource:HasSelectedHero(i) == false then
                    local player = PlayerResource:GetPlayer(i)
                    if player then
                        player:MakeRandomHeroSelection()
                    end
                    --local hero_name = PlayerResource:GetSelectedHeroName(i)
                end
            end
        end
    end
end

function GameMode:NeedSteamIds(data)
    if data == nil or data.PlayerID == nil then return end
    local result = {}
    for i=0,PlayerResource:GetPlayerCount()-1 do
        local arr = {
            PlayerResource:GetSteamID(i),
            PlayerResource:GetSelectedHeroName(i)
        }
        result[i] = arr;
    end
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(data.PlayerID), "SteamIds", result)
end

LinkLuaModifier( "modifier_imba_generic_talents_handler", "modifier/generic_talents/modifier_imba_generic_talents_handler", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_easy_mode", LUA_MODIFIER_MOTION_NONE )
-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	print("[BAREBONES] NPC Spawned")
	DeepPrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)
    
	if npc:IsRealHero() and npc.bFirstSpawned == nil then
        npc.bFirstSpawned = true
        npc.zone = "main_zone"
        npc.immortalbuffs = {}
        npc:AddExperience(100,1,false,false)
		npc:AddNewModifier(npc, nil, "modifier_imba_generic_talents_handler", {})
        --GameMode:CheckWearables(npc)
	    npc:SetGold(475, false)
        local id = npc:GetPlayerID()
        _G.bonuses[1][id] = 0
        _G.bonuses[2][id] = 0
        _G.bonuses[3][id] = 0
        _G.bonuses[4][id] = 0
        _G.bonuses[5][id] = 0
        _G.bonuses[6][id] = 0
        _G.bonuses[7][id] = 0
        npc.sealcolor = 1
        npc.rsp = 0
        local info = {}
        info.PlayerID = id
        Timers:CreateTimer(1, function()
            GameMode:LoadRelics(info)
        end)
        value = {}
        value[1] = 1
        value[2] = 1
        value[3] = 1
        value[4] = 1
        value[5] = 1
        value[6] = 1
        value[7] = 1
        value[8] = 1
        value[9] = 1
        value[10] = 1
        CustomNetTables:SetTableValue("Elements_Tabel",tostring(id),value)

        --seals for all
        -- npc.lvl_item_corrupting_blade = 20
        -- npc.lvl_item_glimmerdark_shield = 20
        -- npc.lvl_item_guardian_shell = 20
        -- npc.lvl_item_dredged_trident = 20
        -- npc.lvl_item_oblivions_locket = 20
        -- npc.lvl_item_ambient_sorcery = 20
        -- npc.lvl_item_wand_of_the_brine = 20
        -- npc.lvl_item_seal_0 = 1
        -- npc.rsinv = ""
        -- npc.rsp = 0
        -- npc.rsslots = ""
        -- npc.rssaves = ""
        
        -- local relicboolarr = {
        --     true,
        --     true,
        --     true,
        --     true,
        --     true,
        --     true,
        --     true,
        --     true
        -- }
        -- npc.seal = true
        -- npc.actseal = true
        -- npc.relicboolarr = relicboolarr
        -- local data = {}
        -- data.PlayerID = id
        -- GameMode:Levels(data)
        ----------------------------

        if not _G.hardmode then
            npc:AddNewModifier(npc, nil, "modifier_easy_mode", {})
        end

        if _G.patreons[tostring(PlayerResource:GetSteamID(id))] ~= nil then
            if _G.patreons[tostring(PlayerResource:GetSteamID(id))] > 3 then
                info.hero = npc
                Pets.CreatePet( info )
            end
        end
	end
end

function GameMode:LoadRelics(info)
    if info == nil or info.PlayerID == nil then return end
    local i = info.PlayerID
    if not PlayerResource:IsValidPlayerID(i) then return end
    local selectheroo = PlayerResource:GetSelectedHeroEntity(i)
    if not selectheroo then return end
    if selectheroo.needrefresh == nil then
        selectheroo.needrefresh = true
    end
    if selectheroo.needrefresh then
        local loaded = false
        print("Start Load")
        selectheroo.needrefresh = false
        local i = info.PlayerID
        -- print("Steam" .. i .. " " .. tostring(PlayerResource:GetSteamID(i)))
        -- print(string.sub(tostring(PlayerResource:GetSteamID(i)),-1))
        local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/lol21.php")
        req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(i)))
        req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
        req:Send(function(result)
            local otv = result.Body
            print(otv)
            if otv ~= "" then
                if otv ~= "none" then
                    local locstr = ""
                    local arrstr = {}
                    --print(i .. " = " .. otv)
                    for n=1, string.len(otv) do
                        if string.char(string.byte(otv, n)) ~= nil then
                            if string.char(string.byte(otv, n)) == " " then
                                table.insert(arrstr, locstr)
                                locstr = ""
                            else
                                locstr = locstr .. string.char(string.byte(otv, n))
                            end
                        end
                    end
                    if locstr ~= "" then
                        table.insert(arrstr, locstr)
                        locstr = ""
                    end
                    if arrstr[#arrstr] == "allok" then
                        loaded = true
                        arrstr[#arrstr] = nil
                        local value = arrstr

                        local seal = true
                        local actseal = true
                        local relicboolarr = {
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                        }
                        --####################################
                        if tonumber(value[1]) > 0 then
                            selectheroo.lvl_item_corrupting_blade = tonumber(value[1])
                            relicboolarr[1] = true
                            if tonumber(value[1]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[1] = nil
                        end
                        if tonumber(value[2]) > 0 then
                            selectheroo.lvl_item_glimmerdark_shield = tonumber(value[2])
                            relicboolarr[2] = true
                            if tonumber(value[2]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[2] = nil
                        end
                        if tonumber(value[3]) > 0 then
                            selectheroo.lvl_item_guardian_shell = tonumber(value[3])
                            relicboolarr[3] = true
                            if tonumber(value[3]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[3] = nil
                        end
                        if tonumber(value[4]) > 0 then
                            selectheroo.lvl_item_dredged_trident = tonumber(value[4])
                            relicboolarr[4] = true
                            if tonumber(value[4]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[4] = nil
                        end
                        if tonumber(value[5]) > 0 then
                            selectheroo.lvl_item_oblivions_locket = tonumber(value[5])
                            relicboolarr[5] = true
                            if tonumber(value[5]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[5] = nil
                        end
                        if tonumber(value[6]) > 0 then
                            selectheroo.lvl_item_ambient_sorcery = tonumber(value[6])
                            relicboolarr[6] = true
                            if tonumber(value[6]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[6] = nil
                        end
                        if tonumber(value[7]) > 0 then
                            selectheroo.lvl_item_wand_of_the_brine = tonumber(value[7])
                            relicboolarr[7] = true
                            if tonumber(value[7]) < 20 then
                                actseal = false
                            end
                        else
                            seal = false
                            actseal = false
                            value[7] = nil
                        end
                        if tonumber(value[8]) > 0 then
                            selectheroo.lvl_item_seal_0 = tonumber(value[8])
                            relicboolarr[8] = true
                        else
                            seal = false
                            actseal = false
                            value[8] = nil
                        end
                        --####################################
                        selectheroo.seal = seal
                        selectheroo.actseal = actseal
                        selectheroo.relicboolarr = relicboolarr
                        selectheroo.sealcolors = {}
                        local arrstr2 = {}
                        for n=1, string.len(value[18]) do
                            if string.char(string.byte(value[18], n)) ~= nil then
                                if string.char(string.byte(value[18], n)) == "|" then
                                    table.insert(arrstr2, locstr)
                                    locstr = ""
                                else
                                    locstr = locstr .. string.char(string.byte(value[18], n))
                                end
                            end
                        end
                        if locstr ~= "" then
                            table.insert(arrstr2, locstr)
                            locstr = ""
                        end
                        selectheroo.rsinv = arrstr2
                        selectheroo.rsp = tonumber(value[9])
                        selectheroo.rsslots = {"","","","","","","",""}
                        selectheroo.rssaves = {value[10],value[11],value[12],value[13],value[14],value[15],value[16],value[17]}
                        local data = {}
                        data.PlayerID = i
                        data.num = 1
                        GameMode:LoadSet(data)
                        if selectheroo.rsslots[1] ~= "" then
                            selectheroo.sealcolor = tonumber(string.sub(selectheroo.rsslots[1], 2, 2))+2
                        else
                            selectheroo.sealcolor = 1
                        end
                        if _G.patreons[tostring(PlayerResource:GetSteamID(i))] ~= nil then
                            if _G.patreons[tostring(PlayerResource:GetSteamID(i))] > 2 then
                                selectheroo.sealcolor = 12
                            end
                        end
                        GameMode:Levels(data)
                    end
                else
                    loaded = true
                    local selectheroo = PlayerResource:GetSelectedHeroEntity(i)
                    selectheroo.nullrelics = true
                end
            end
        end)
        
        Timers:CreateTimer(10, function()
            if loaded == false then
                selectheroo.needrefresh = true
                CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "NeedRefresh", {})
            end
        end)
    end
end
-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
	--print("[BAREBONES] Entity Hurt")
	--DeepPrintTable(keys)
	--local entCause = EntIndexToHScript(keys.entindex_attacker)
	--local entVictim = EntIndexToHScript(keys.entindex_killed)
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	print ( '[BAREBONES] OnItemPickedUp' )
	DeepPrintTable(keys)

	-- local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
    
    if itemname == "item_25gold" then
		local plc = PlayerResource:GetPlayerCount()
        local value = (280 / (plc + 2))
        for nPlayerID = 0, plc-1 do
            if PlayerResource:IsValidPlayer( nPlayerID ) then
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                    SendOverheadEventMessage( hero, OVERHEAD_ALERT_GOLD, hero, value, nil )
                    PlayerResource:ModifyGold(nPlayerID,value,true,DOTA_ModifyGold_Unspecified)
				end
            end
		end
        if not itemEntity:IsNull() then
            itemEntity:Destroy()
        end
    --else
        --GameMode:Check()
    -- elseif itemname == "item_shadow_portal" then
    --     _G.portal_item = CreateItem("item_shadow_portal", nil, nil)
    --     _G.portal_item_drop = CreateItemOnPositionSync( Entities:FindByName( nil, "spawner"):GetAbsOrigin(), _G.portal_item )
    end
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnLoadPlayerVote(keys)
	-- print ( 'OnLoadPlayerVote' )
	-- DeepPrintTable(keys)
    local ttime = GameMode:GetTimeToWave()
    if keys ~= nil and keys.PlayerID ~= nil and ttime > 1 and ttime < 60 then
        local heroes = GetAllRealHeroes()
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetSelectedHeroEntity(keys.PlayerID), "Display_RoundVote", { count = #heroes })
    end
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
	print ( '[BAREBONES] OnItemPurchased' )
	DeepPrintTable(keys)

	-- The playerID of the hero who is buying something
	--local plyID = keys.PlayerID
	--if not plyID then return end

	-- The name of the item purchased
	--local itemName = keys.itemname

	-- The cost of the item purchased
	--local itemcost = keys.itemcost

end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
	print('[BAREBONES] AbilityUsed')
	DeepPrintTable(keys)

	--local player = EntIndexToHScript(keys.PlayerID)
	--local abilityname = keys.abilityname
end

LinkLuaModifier( "modifier_my_black_king_bar", "modifiers/modifier_my_black_king_bar", LUA_MODIFIER_MOTION_NONE )
-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
	print('[BAREBONES] OnNonPlayerUsedAbility')
	DeepPrintTable(keys)

	local abilityname = keys.abilityname
    
    if abilityname == "elder_titan_echo_stomp" then
        local caster = EntIndexToHScript(keys.caster_entindex)
        
        caster:AddNewModifier(caster, nil, "modifier_my_black_king_bar", {duration = 1.8})
    elseif abilityname == "phoenix_sun_ray_datadriven" then
        local caster = EntIndexToHScript(keys.caster_entindex)
        
        caster:AddNewModifier(caster, nil, "modifier_my_black_king_bar", {duration = 6.1})
    end
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
	print('[BAREBONES] OnPlayerChangedName')
	DeepPrintTable(keys)

	--local newName = keys.newname
	--local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
	print ('[BAREBONES] OnPlayerLearnedAbility')
	DeepPrintTable(keys)

	--local player = EntIndexToHScript(keys.player)
    -- local abilityname = keys.abilityname
    -- local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
    
    -- if hero:GetLevel() == 29 then
    --     if string.find(abilityname, "special_bonus") then
    --         for i=0,hero:GetAbilityCount()-1 do
    --             local abil = hero:GetAbilityByIndex(i)
    --             if abil and abil:GetAbilityName() == abilityname then
    --                 hero.talents[i] = abil:GetLevel()
    --             end
    --         end
    --     end
    -- end
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
	print ('[BAREBONES] OnAbilityChannelFinished')
	DeepPrintTable(keys)

	--local abilityname = keys.abilityname
	--local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
	print ('[BAREBONES] OnPlayerLevelUp')
	DeepPrintTable(keys)

	--local player = EntIndexToHScript(keys.player)
    local hero = EntIndexToHScript(keys.hero_entindex)
    local level = keys.level
    local ability_point = hero:GetAbilityPoints()
    
    -- if level == 29 then
    --     hero.talents = {}
    --     for i=0,hero:GetAbilityCount()-1 do
    --         local abil = hero:GetAbilityByIndex(i)
    --         if abil and string.find(abil:GetAbilityName(), "special_bonus") then
    --             hero.talents[i] = abil:GetLevel()
    --         end
    --     end
    -- end
    
    -- if level == 30 then
    --     Timers:CreateTimer(0.1, function()
    --         for abilityindex, abilitylevel in pairs(hero.talents) do
    --             hero:GetAbilityByIndex(abilityindex):SetLevel(abilitylevel)
    --         end
    --         hero.talents = nil
    --     end)
    -- end

    if level >= 30 then
        hero:SetAbilityPoints(ability_point + 1)
    end
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
	print ('[BAREBONES] OnLastHit')
	DeepPrintTable(keys)

	--local isFirstBlood = keys.FirstBlood == 1
	--local isHeroKill = keys.HeroKill == 1
	--local isTowerKill = keys.TowerKill == 1
	--local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
	print ('[BAREBONES] OnTreeCut')
	DeepPrintTable(keys)

	--local treeX = keys.tree_x
	--local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
	print ('[BAREBONES] OnRuneActivated')
	DeepPrintTable(keys)

	--local player = PlayerResource:GetPlayer(keys.PlayerID)
	--local rune = keys.rune

end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
	print ('[BAREBONES] OnPlayerTakeTowerDamage')
	DeepPrintTable(keys)

	--local player = PlayerResource:GetPlayer(keys.PlayerID)
	--local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
	print ('[BAREBONES] OnPlayerPickHero')
	DeepPrintTable(keys)

	local heroClass = keys.hero
	local heroEntity = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        for i=0, 9, 1 do
            local current_item = heroEntity:GetItemInSlot(i)
            if current_item ~= nil then
                heroEntity:RemoveItem(current_item)
            end
        end
    end
    local current_item = heroEntity:GetItemInSlot(16)
    if current_item ~= nil then
        if current_item:GetName() == "item_tpscroll" then
            heroEntity:RemoveItem(current_item)
        end
    end
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
	print ('[BAREBONES] OnTeamKillCredit')
	DeepPrintTable(keys)

	--local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	--local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	--local numKills = keys.herokills

	--local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	print( '[BAREBONES] OnEntityKilled Called' )
	DeepPrintTable( keys )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
    
    local plc = PlayerResource:GetPlayerCount()
    
    if killedUnit:GetUnitLabel() == "npc_dota_custom_creep_50_1" and not _G.shadow_arena then
        GameMode:_Stats("1")
        for i=0,plc-1 do
            local sch = PlayerResource:GetSelectedHeroEntity(i).damage_schetchik
            if sch == nil then
                sch = 0
            end
            local tbl = {
                tdmg = PlayerResource:GetCreepDamageTaken(i,true),
                heal = PlayerResource:GetHealing(i),
                last = PlayerResource:GetLastHits(i),
                ddmg = math.ceil(sch)
            }
            CustomNetTables:SetTableValue("Hero_Stats",tostring(i),tbl)
        end
        Timers:CreateTimer(0.1, function()
            GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
        end)
    end
    
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end
    
	if killedUnit and killedUnit:IsRealHero() then
		local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
		newItem:SetPurchaseTime( 0 )
		newItem:SetPurchaser( killedUnit )
		local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
		tombstone:SetContainedItem( newItem )
		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
		FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true )	
	end
    
    if killedUnit:GetTeam() == 3 and killedUnit:GetName() == "npc_dota_creature" then
        if GameMode:GetTimeToWave() == 0 then
            local test1 = Entities:FindAllByName("npc_dota_creature")
            local nextwave = true
            if test1 ~= nil then
                if #test1 ~= 0 then
                    for b=1,#test1 do
                        if test1[b]:GetTeam() == 3 and test1[b]:IsAlive() == true then
                            nextwave = false
                        end
                    end
                end
            end
            Timers:CreateTimer(0.01, function()
                local test1 = Entities:FindAllByName("npc_dota_creature")
                if test1 ~= nil then
                    if #test1 ~= 0 then
                        for b=1,#test1 do
                            if test1[b]:GetTeam() == 3 and test1[b]:IsAlive() == true then
                                nextwave = false
                            end
                        end
                    end
                end
                if nextwave == true then
                    if _G.shadow_arena then
                        if not _G.shadow_arena_spawning then
                            GameMode:StopShadowArena(true)
                        end
                    else
                        GameMode:OnGameInProgress()
                    end
                else
                    Timers:CreateTimer(1, function()
                        if GameMode:GetTimeToWave() == 0 then
                            local test2 = Entities:FindAllByName("npc_dota_creature")
                            local nextwave = true
                            if test2 ~= nil then
                                if #test2 ~= 0 then
                                    for b=1,#test2 do
                                        if test2[b]:GetTeam() == 3 and test2[b]:IsAlive() == true then
                                            nextwave = false
                                        end
                                    end
                                end
                            end
                            Timers:CreateTimer(0.01, function()
                                local test2 = Entities:FindAllByName("npc_dota_creature")
                                if test2 ~= nil then
                                    if #test2 ~= 0 then
                                        for b=1,#test2 do
                                            if test2[b]:GetTeam() == 3 and test2[b]:IsAlive() == true then
                                                nextwave = false
                                            end
                                        end
                                    end
                                end
                                if nextwave == true then
                                    if _G.shadow_arena then
                                        if not _G.shadow_arena_spawning then
                                            GameMode:StopShadowArena(true)
                                        end
                                    else
                                        GameMode:OnGameInProgress()
                                    end
                                end
                            end)
                        end
                    end)
                end
            end)
        end
        if not killedUnit:IsIllusion() and not _G.shadow_arena then
            local getxp = killedUnit:GetBaseDayTimeVisionRange()
            if getxp > 0 then
                local heroes = GetAllRealHeroes()
                for i=1, #heroes do
                    heroes[i]:AddExperience((getxp / #heroes)*(1-(0.05*(5 - #heroes))),false,false)
                end
            end
        end
    end

    if killedUnit:IsCreature() then
        if not _G.shadow_arena then
            RollDrops(killedUnit)
        else
            local tiers = {
                10,
                4,
                1,
                1
            }
            if killedUnit.tier and RandomInt(1,tiers[killedUnit.tier]) == 1 then
                local item = CreateItem("item_25gold", nil, nil)
                item:SetPurchaseTime(0)
                local pos = killedUnit:GetAbsOrigin()
                local drop = CreateItemOnPositionSync( pos, item )
                local pos_launch = pos+RandomVector(RandomFloat(150,200))
                item:LaunchLoot(false, 200, 0.75, pos_launch)
            end
        end
        -- if not GameRules:IsCheatMode() then
        --     if killedUnit:GetUnitLabel() == "npc_dota_custom_creep_5_1" then
        --         for i=0,plc-1 do
        --             local pl = PlayerResource:GetSelectedHeroEntity(i)
        --             if pl.nullrelics == true then
        --                 local rlcsfd = {
        --                     "item_corrupting_blade",
        --                     "item_glimmerdark_shield",
        --                     "item_guardian_shell",
        --                     "item_dredged_trident",
        --                     "item_oblivions_locket",
        --                     "item_ambient_sorcery",
        --                     "item_wand_of_the_brine"
        --                 }
        --                 local item_name = rlcsfd[RandomInt(1, #rlcsfd)]
        --                 local item = CreateItem(item_name, nil, nil)
        --                 item:SetPurchaseTime(0)
        --                 local pos = killedUnit:GetAbsOrigin()
        --                 local drop = CreateItemOnPositionSync( pos, item )
        --                 local pos_launch = pos+RandomVector(RandomFloat(100,125))
        --                 item:LaunchLoot(false, 200, 0.75, pos_launch)
        --                 item.bIsRelic = true
        --                 item:SetPurchaser( pl )
        --                 local otv = ""
        --                 local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "mygamesonline.org/lol21.php")
        --                 req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamID(pl)))
        --                 req:SetHTTPRequestGetOrPostParameter("name", item_name)
        --                 req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
        --                 req:Send(function(result)
        --                     otv = result.Body
        --                 end)
        --             end
        --         end
        --     end
        -- end
    end
	-- Put code here to handle when an entity gets killed
end


allelements = {
    "item_ice",
    "item_fire",
    "item_water",
    "item_energy",
    "item_earth",
    "item_life",
    "item_void",
    "item_air",
    "item_light",
    "item_shadow"
}
needdropel = {}

function RollDrops(unit)
    local DropInfo = GameRules.DropTable[unit:GetUnitName()]
    if DropInfo then
        for k,ItemTable in pairs(DropInfo) do
            local chance = ItemTable.Chance or 100
            local max_drops = ItemTable.Multiple or 1
            local item_name = ItemTable.Item
            local item_relict = ItemTable.Relict
            for i=1,max_drops do
                if item_name ~= "item_25gold" then
                    if item_relict == 1 then
                        if not GameRules:IsCheatMode() then
                            if RollPercentage(chance*PlayerResource:GetPlayerCount()) then
                                local item = CreateItem(item_name, nil, nil)
                                item:SetPurchaseTime(0)
                                local pos = unit:GetAbsOrigin()
                                local drop = CreateItemOnPositionSync( pos, item )
                                local pos_launch = pos+RandomVector(RandomFloat(100,125))
                                item:LaunchLoot(false, 200, 0.75, pos_launch)
                                item.bIsRelic = true
                                local PlayerIDs = {}
                                print( "CDungeon:OnRelicSpawned - New Relic " .. item:GetAbilityName() .. " created." )
                                local Heroes = HeroList:GetAllHeroes()
                                for _,Hero in pairs ( Heroes ) do
                                    if Hero ~= nil and Hero:IsRealHero() and Hero:HasOwnerAbandoned() == false and PlayerResource:GetConnectionState(Hero:GetPlayerID()) == 2 then
                                        print( "CDungeon:OnRelicSpawned - PlayerID " .. Hero:GetPlayerID() .. " does not own item, adding to grant list." )
                                        table.insert( PlayerIDs, Hero:GetPlayerID() )
                                    end
                                end

                                local WinningPlayerID = -1
                                if #PlayerIDs == 1 then
                                    WinningPlayerID = PlayerIDs[1]
                                else
                                    WinningPlayerID = PlayerIDs[ RandomInt( 1, #PlayerIDs ) ]
                                    print( "CDungeon:OnRelicSpawned - " .. #PlayerIDs .. " players have not yet found an artifact, winner is player ID " .. WinningPlayerID )
                                end

                                if WinningPlayerID == -1 or WinningPlayerID == nil then
                                    print( "CDungeon:OnRelicSpawned - ERROR - WinningPlayerID is invalid." )
                                    return
                                end
                                
                                local WinningHero = PlayerResource:GetSelectedHeroEntity( WinningPlayerID )
                                local WinningSteamID = PlayerResource:GetSteamID( WinningPlayerID )

                                print( "CDungeon:OnRelicSpawned - Relic " .. item:GetAbilityName() .. " has been bound to " .. WinningPlayerID )
                                item:SetPurchaser( WinningHero )
                                
                                if item_name == "item_corrupting_blade" then
                                    if WinningHero.lvl_item_corrupting_blade ~= nil then
                                        WinningHero.lvl_item_corrupting_blade = WinningHero.lvl_item_corrupting_blade + 1
                                    else
                                        WinningHero.lvl_item_corrupting_blade = 1
                                    end
                                end
                                if item_name == "item_glimmerdark_shield" then
                                    if WinningHero.lvl_item_glimmerdark_shield ~= nil then
                                        WinningHero.lvl_item_glimmerdark_shield = WinningHero.lvl_item_glimmerdark_shield + 1
                                    else
                                        WinningHero.lvl_item_glimmerdark_shield = 1
                                    end
                                end
                                if item_name == "item_guardian_shell" then
                                    if WinningHero.lvl_item_guardian_shell ~= nil then
                                        WinningHero.lvl_item_guardian_shell = WinningHero.lvl_item_guardian_shell + 1
                                    else
                                        WinningHero.lvl_item_guardian_shell = 1
                                    end
                                end
                                if item_name == "item_dredged_trident" then
                                    if WinningHero.lvl_item_dredged_trident ~= nil then
                                        WinningHero.lvl_item_dredged_trident = WinningHero.lvl_item_dredged_trident + 1
                                    else
                                        WinningHero.lvl_item_dredged_trident = 1
                                    end
                                end
                                if item_name == "item_oblivions_locket" then
                                    if WinningHero.lvl_item_oblivions_locket ~= nil then
                                        WinningHero.lvl_item_oblivions_locket = WinningHero.lvl_item_oblivions_locket + 1
                                    else
                                        WinningHero.lvl_item_oblivions_locket = 1
                                    end
                                end
                                if item_name == "item_ambient_sorcery" then
                                    if WinningHero.lvl_item_ambient_sorcery ~= nil then
                                    WinningHero.lvl_item_ambient_sorcery = WinningHero.lvl_item_ambient_sorcery + 1
                                    else
                                        WinningHero.lvl_item_ambient_sorcery = 1
                                    end
                                end
                                if item_name == "item_wand_of_the_brine" then
                                    if WinningHero.lvl_item_wand_of_the_brine ~= nil then
                                        WinningHero.lvl_item_wand_of_the_brine = WinningHero.lvl_item_wand_of_the_brine + 1
                                    else
                                        WinningHero.lvl_item_wand_of_the_brine = 1
                                    end
                                end
                                
                                --EmitSoundOn( "Hero_LegionCommander.Duel.Victory", WinningHero )
                                local otv = ""
                                local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/lol21.php")
                                req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                req:SetHTTPRequestGetOrPostParameter("name", item_name)
                                req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
                                req:Send(function(result)
                                    otv = result.Body
                                end)
                            end
                        end
                    else
                        if item_name == "RS" then
                            if not GameRules:IsCheatMode() then
                                if RollPercentage(chance*PlayerResource:GetPlayerCount()) then
                                    local PlayerIDs = {}
                                    local Heroes = HeroList:GetAllHeroes()
                                    for _,Hero in pairs ( Heroes ) do
                                        if Hero ~= nil and Hero:IsRealHero() and Hero:HasOwnerAbandoned() == false and PlayerResource:GetConnectionState(Hero:GetPlayerID()) == 2 then
                                            table.insert( PlayerIDs, Hero:GetPlayerID() )
                                        end
                                    end
    
                                    local WinningPlayerID = -1
                                    if #PlayerIDs == 1 then
                                        WinningPlayerID = PlayerIDs[1]
                                    else
                                        WinningPlayerID = PlayerIDs[ RandomInt( 1, #PlayerIDs ) ]
                                    end
                                    if WinningPlayerID == -1 or WinningPlayerID == nil then
                                        print( "CDungeon:OnRelicSpawned - ERROR - WinningPlayerID is invalid." )
                                        return
                                    end
                                    
                                    local WinningHero = PlayerResource:GetSelectedHeroEntity( WinningPlayerID )
                                    local WinningSteamID = PlayerResource:GetSteamID( WinningPlayerID )
                                    local ininvid = ""
                                    if WinningHero.rsinv ~= nil then
                                        if #WinningHero.rsinv > 99 then
                                            ininvid = tostring(#WinningHero.rsinv)
                                        elseif #WinningHero.rsinv > 9 then
                                            ininvid = "0"..tostring(#WinningHero.rsinv)
                                        elseif #WinningHero.rsinv > -1 then
                                            ininvid = "00"..tostring(#WinningHero.rsinv)
                                        end
                                    else
                                        ininvid = "001"
                                    end

                                    local rares = ItemTable.Rares

                                    local rsid = nil
                                    if rares == 0 then
                                        rsid = "1"..RandomInt(0,9)..RandomInt(1,4)..RandomInt(1,7).."0000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                    elseif rares == 1 then
                                        rsid = RandomInt(1,2)..RandomInt(0,9)..RandomInt(1,4)..RandomInt(1,7).."0000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                    elseif rares == 2 then
                                        rsid = "2"..RandomInt(0,9)..RandomInt(1,4)..RandomInt(1,7).."0000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                    elseif rares == 3 then
                                        local rrr = RandomInt(1,3)
                                        local secstat = 0
                                        if rrr == 3 then
                                            secstat = RandomInt(1,7)
                                        end
                                        rsid = rrr..RandomInt(0,9)..RandomInt(1,4)..RandomInt(1,7)..secstat.."000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                    elseif rares == 4 then
                                        local rrr = RandomInt(2,3)
                                        local secstat = 0
                                        if rrr == 3 then
                                            secstat = RandomInt(1,7)
                                        end
                                        rsid = rrr..RandomInt(0,9)..RandomInt(1,4)..RandomInt(1,7)..secstat.."000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                    elseif rares == 5 then
                                        rsid = "3"..RandomInt(0,9)..RandomInt(1,4)..RandomInt(1,7)..RandomInt(1,7).."000"..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                    elseif rares == 6 then

                                    elseif rares == 7 then

                                    elseif rares == 8 then

                                    elseif rares == 9 then
                                        local stat1 = RandomInt(1,7)
                                        local stat2 = RandomInt(1,6)
                                        if stat2 >= stat1 then
                                            stat2 = stat2 + 1
                                        end
                                        local modid = RandomInt(1,6)
                                        if modid < 10 then
                                            modid = "0" .. modid
                                        end
                                        rsid = "4"..RandomInt(0,9)..RandomInt(1,4)..stat1..stat2..modid..RandomInt(0,2)..ininvid
                                        if WinningHero.rsinv ~= nil then
                                            table.insert(WinningHero.rsinv,rsid)
                                        else
                                            WinningHero.rsinv = {rsid}
                                        end
                                    end

                                    if rsid ~= nil then
                                        CustomGameEventManager:Send_ServerToAllClients( "AddRSUI", {rsid = rsid,hero = WinningHero:GetName()})
                                        local otv = ""
                                        local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/relicstones1.php")
                                        req:SetHTTPRequestGetOrPostParameter("id", tostring(WinningSteamID))
                                        req:SetHTTPRequestGetOrPostParameter("rsid", rsid)
                                        req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
                                        req:Send(function(result)
                                            otv = result.Body
                                        end)
                                    end
                                end
                            end
                        elseif item_name == "all_elements" then
                            for z=0, PlayerResource:GetPlayerCount()-1 do
                                local myTable = CustomNetTables:GetTableValue("Elements_Tabel",tostring(z))
                                if myTable == nil then
                                    myTable = {}
                                end
                                for y=1, 10 do
                                    if myTable[tostring(y)] == nil then
                                        myTable[tostring(y)] = 0
                                    end
                                    myTable[tostring(y)] = myTable[tostring(y)] + 1
                                    --local item = CreateItem(allelements[y], nil, nil)
                                    --item:SetPurchaseTime(0)
                                    --local rotationAngle = 0 - 45 - (36 * y)
                                    --local relPos = Vector( 0, 300, 0 )
                                    --relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                                    --local absPos = GetGroundPosition( relPos + casterOrigin, newSpirit )
                                    --newSpirit:SetAbsOrigin( absPos )
                                    --local pos = unit:GetAbsOrigin()
                                    --CreateItemOnPositionSync( relPos, item )
                                end
                                CustomNetTables:SetTableValue("Elements_Tabel",tostring(z),myTable)
                            end
                        else
                            local randomel = true
                            if randomel == true then
                                if #needdropel == 0 then
                                    for y=1,#allelements do
                                        table.insert(needdropel, allelements[y])
                                    end
                                end
                                local rand = RandomInt( 1, #needdropel )
                                item_name = needdropel[rand]
                                table.remove(needdropel, rand)
                            end
                            for z=0, PlayerResource:GetPlayerCount()-1 do
                                local myTable = CustomNetTables:GetTableValue("Elements_Tabel",tostring(z))
                                if myTable == nil then
                                    myTable = {}
                                end
                                for y=1, #allelements do
                                    if allelements[y] == item_name then
                                        local partlist = {
                                        "particles/my_new/elements/ice/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/fire/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/water/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/energy/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/earth/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/life/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/void/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/air/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/light/doom_bringer_devour.vpcf",
                                        "particles/my_new/elements/shadow/doom_bringer_devour.vpcf"
                                        }
                                        
                                        local parthero = PlayerResource:GetSelectedHeroEntity(z)
                                        if parthero then
                                            local nFXIndex = ParticleManager:CreateParticle( partlist[y], PATTACH_ABSORIGIN, unit )
                                            --ParticleManager:SetParticleControl( nFXIndex, 0, drop_item:GetAbsOrigin() )
                                            --ParticleManager:SetParticleControl( nFXIndex, 1, containedItem:GetPurchaser():GetAbsOrigin() )
                                            ParticleManager:SetParticleControlEnt( nFXIndex, 1, PlayerResource:GetSelectedHeroEntity(z), PATTACH_POINT_FOLLOW, "attach_hitloc", parthero:GetOrigin(), true )
                                            ParticleManager:ReleaseParticleIndex( nFXIndex )
                                        end
                                        
                                        if myTable[tostring(y)] == nil then
                                            myTable[tostring(y)] = 0
                                        end
                                        myTable[tostring(y)] = myTable[tostring(y)] + 1
                                        CustomNetTables:SetTableValue("Elements_Tabel",tostring(z),myTable)
                                        break
                                    end
                                end
                            end
                                --local item = CreateItem(item_name, nil, nil)
                                --item:SetPurchaseTime(0)
                                --local pos = unit:GetAbsOrigin()
                                --local drop = CreateItemOnPositionSync( pos, item )
                                --local pos_launch = pos+RandomVector(RandomFloat(150,200))
                                --item:LaunchLoot(false, 0, 0, pos_launch)
                        end
                    end
                else
                    if RollPercentage(chance) then
                        local item = CreateItem(item_name, nil, nil)
                        item:SetPurchaseTime(0)
                        local pos = unit:GetAbsOrigin()
                        local drop = CreateItemOnPositionSync( pos, item )
                        local pos_launch = pos+RandomVector(RandomFloat(150,200))
                        item:LaunchLoot(false, 200, 0.75, pos_launch)
                    end
                end
            end
        end
    end
end

function GameMode:GetElementCol( hero )
    local elements = {
    item_ice = 1,
    item_fire = 1,
    item_water = 1,
    item_energy = 1,
    item_earth = 1,
    item_life = 1,
    item_void = 1,
    item_air = 1,
    item_light = 1,
    item_shadow = 1
    }
    local elementcol = 0
    
    for y=0, 15, 1 do
        local current_item = hero:GetItemInSlot(y)
        if current_item ~= nil then
            if elements[current_item:GetName()] == 1 then
                elementcol = elementcol + 1
            end
        end
    end
        
    print(elementcol)
    return elementcol
end

function GameMode:ItemAddedToInventoryFilter( filterTable )
	if filterTable["item_entindex_const"] == nil then 
		return true
	end

 	if filterTable["inventory_parent_entindex_const"] == nil then
		return true
	end

	local hItem = EntIndexToHScript( filterTable["item_entindex_const"] )
	local hInventoryParent = EntIndexToHScript( filterTable["inventory_parent_entindex_const"] )
    
    --[[
    local elements = {
    item_ice = 1,
    item_fire = 1,
    item_water = 1,
    item_energy = 1,
    item_earth = 1,
    item_life = 1,
    item_void = 1,
    item_air = 1,
    item_light = 1,
    item_shadow = 1
    }
    
    if PlayerResource:GetPlayerCount() > 1 then
        Timers:CreateTimer(0.1,function()
            local elementcol = GameMode:GetElementCol( hInventoryParent )
            if elementcol > 0 then
                Timers:CreateTimer(11 - elementcol,function()
                    local nowelementcol = GameMode:GetElementCol( hInventoryParent )
                    if elementcol >= nowelementcol then
                        for y=0, 15, 1 do
                            local current_item = hInventoryParent:GetItemInSlot(y)
                            if current_item ~= nil then
                                if elements[current_item:GetName()] == 1 then
                                    hInventoryParent:DropItemAtPositionImmediate( current_item, hInventoryParent:GetAbsOrigin() )
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
    ]]
	if hItem ~= nil and hInventoryParent ~= nil and hItem:GetAbilityName() ~= "item_tombstone" and hInventoryParent:IsRealHero() then
        local rlcs = {
        item_corrupting_blade = 1,
        item_glimmerdark_shield = 1,
        item_guardian_shell = 1,
        item_dredged_trident = 1,
        item_oblivions_locket = 1,
        item_ambient_sorcery = 1,
        item_wand_of_the_brine = 1,
        item_seal_0 = 1,
        item_seal_act_r = 1,
        item_seal_1 = 2,
        item_seal_act = 3,
        item_op_staff = 4,
        item_shadow_cuirass = 4,
        item_ice_staff = 4
        }
        if rlcs[hItem:GetAbilityName()] == nil then
            local notforall = {
            "item_ice",
            "item_fire",
            "item_water",
            "item_energy",
            "item_earth",
            "item_life",
            "item_void",
            "item_air",
            "item_light",
            "item_shadow",
            "item_ice_essence",
            "item_fire_essence",
            "item_water_essence",
            "item_energy_essence",
            "item_earth_essence",
            "item_life_essence",
            "item_void_essence",
            "item_air_essence",
            "item_light_essence",
            "item_shadow_essence",
            "item_ice_dummy",
            "item_fire_dummy",
            "item_water_dummy",
            "item_energy_dummy",
            "item_earth_dummy",
            "item_life_dummy",
            "item_void_dummy",
            "item_air_dummy",
            "item_light_dummy",
            "item_shadow_dummy",
            "item_upgraded_mjollnir",
            "item_upgraded_heart",
            "item_upgraded_greater_crit",
            "item_upgraded_satanic",
            "item_upgraded_pipe",
            "item_upgraded_desolator",
            "item_upgraded_octarine_core",
            "item_upgraded_diffusal_blade",
            "item_upgraded_sange_and_yasha",
            "item_upgraded_butterfly",
            "item_upgraded_monkey_king_bar",
            "item_light_fire_earth",
            "item_light_life_ice",
            "item_air_earth_shadow",
            "item_air_life_void",
            "item_air_fire_life",
            "item_energy_fire_void",
            "item_energy_shadow_water",
            "item_energy_earth_water",
            "item_energy_void_ice",
            "item_energy_light_air",
            "item_energy_life_fire",
            "item_fire_earth_water",
            "item_water_life_shadow",
            "item_light_water_void",
            "item_ice_air_water",
            "item_light_life_earth",
            "item_shadow_light_ice",
            "item_ice_shadow_air",
            "item_void_fire_shadow",
            "item_void_ice_earth",
            "item_air_void_water",
            "item_air_fire_light",
            "item_air_earth_energy",
            "item_void_shadow_water",
            "item_water_ice_fire",
            "item_void_light_life",
            "item_earth_shadow_life",
            "item_shadow_energy_light",
            "item_ice_fire_earth",
            "item_ice_life_energy",
            "item_light_fire_earth_2",
            "item_light_life_ice_2",
            "item_air_earth_shadow_2",
            "item_air_life_void_2",
            "item_air_fire_life_2",
            "item_energy_fire_void_2",
            "item_energy_shadow_water_2",
            "item_energy_earth_water_2",
            "item_energy_void_ice_2",
            "item_energy_light_air_2",
            "item_energy_life_fire_2",
            "item_fire_earth_water_2",
            "item_water_life_shadow_2",
            "item_light_water_void_2",
            "item_ice_air_water_2",
            "item_light_life_earth_2",
            "item_shadow_light_ice_2",
            "item_ice_shadow_air_2",
            "item_void_fire_shadow_2",
            "item_void_ice_earth_2",
            "item_air_void_water_2",
            "item_air_fire_light_2",
            "item_air_earth_energy_2",
            "item_void_shadow_water_2",
            "item_water_ice_fire_2",
            "item_void_light_life_2",
            "item_earth_shadow_life_2",
            "item_shadow_energy_light_2",
            "item_ice_fire_earth_2",
            "item_ice_life_energy_2",
            "item_light_fire_earth_3",
            "item_light_life_ice_3",
            "item_air_earth_shadow_3",
            "item_air_life_void_3",
            "item_air_fire_life_3",
            "item_energy_fire_void_3",
            "item_energy_shadow_water_3",
            "item_energy_earth_water_3",
            "item_energy_void_ice_3",
            "item_energy_light_air_3",
            "item_energy_life_fire_3",
            "item_fire_earth_water_3",
            "item_water_life_shadow_3",
            "item_light_water_void_3",
            "item_ice_air_water_3",
            "item_light_life_earth_3",
            "item_shadow_light_ice_3",
            "item_ice_shadow_air_3",
            "item_void_fire_shadow_3",
            "item_void_ice_earth_3",
            "item_air_void_water_3",
            "item_air_fire_light_3",
            "item_air_earth_energy_3",
            "item_void_shadow_water_3",
            "item_water_ice_fire_3",
            "item_void_light_life_3",
            "item_earth_shadow_life_3",
            "item_shadow_energy_light_3",
            "item_ice_fire_earth_3",
            "item_ice_life_energy_3",
            "item_power_dagon",
            "item_fire_radiance",
            "item_life_greaves",
            "item_fire_desol",
            "item_water_butterfly",
            "item_shivas_shield",
            "item_energy_sphere",
            "item_water_blades",
            "item_energy_core",
            "item_power_satanic",
            "item_heart_of_light",
            "item_earth_cuirass",
            "item_dragon_staff",
            "item_earth_s_and_y",
            "item_ice_pipe",
            "item_fire_core",
            "item_solar_crest_of_void",
            "item_talisman_of_atos",
            "item_vessel_of_the_souls",
            "item_skadi_bow",
            "item_monkey_king_bow",
            "item_mystery_cyclone",
            "item_kingsbane",
            "item_energy_veil",
            "item_vampire_robe",
            "item_mana_blade",
            "item_ice_aluneth",
            "item_my_crit",
            "item_avernus_chestplate",
            "item_hammer_of_god"
            }
            local est2 = false
            for k, v in pairs(notforall) do
                if v == hItem:GetAbilityName() then
                    est2 = true
                end
            end
            if est2 == false then
                hItem:SetPurchaser( hInventoryParent )
            else
                if hItem:GetPurchaser() ~= hInventoryParent then
                    Timers:CreateTimer(0.01,function()
                        hInventoryParent:DropItemAtPositionImmediate( hItem, hInventoryParent:GetAbsOrigin() )
                    end)
                end
            end
        else
            if hItem:GetPurchaser() ~= hInventoryParent then
                Timers:CreateTimer(0.01,function()
                    hInventoryParent:DropItemAtPositionImmediate( hItem, hInventoryParent:GetAbsOrigin() )
                end)
            else
                for i=0, 9, 1 do
                    local current_item = hInventoryParent:GetItemInSlot(i)
                    if current_item ~= nil then
                        if rlcs[current_item:GetAbilityName()] ~= nil then
                            if rlcs[hItem:GetAbilityName()] > rlcs[current_item:GetAbilityName()] then
                                hInventoryParent:RemoveItem(current_item)
                            else
                                if rlcs[hItem:GetAbilityName()] < rlcs[current_item:GetAbilityName()] then
                                    Timers:CreateTimer(0.01,function()
                                        hInventoryParent:RemoveItem(hItem)
                                    end)
                                else
                                    if hItem:GetAbilityName() == current_item:GetAbilityName() then
                                        Timers:CreateTimer(0.01,function()
                                            hInventoryParent:RemoveItem(hItem)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
	end
	return true
end

----------------------------------------------------------------
-- "Custom" modifier value fetching
----------------------------------------------------------------

-- Spell lifesteal
function CDOTA_BaseNPC:GetSpellLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellLifesteal then
			lifesteal = lifesteal + parent_modifier:GetModifierSpellLifesteal()
		end
	end
	return lifesteal
end

-- Autoattack lifesteal
function CDOTA_BaseNPC:GetLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierLifesteal then
			lifesteal = lifesteal + parent_modifier:GetModifierLifesteal()
		end
	end
	return lifesteal
end

-- Health regeneration % amplification
function CDOTA_BaseNPC:GetHealthRegenAmp()
	local regen_increase = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierHealthRegenAmp then
			regen_increase = regen_increase + parent_modifier:GetModifierHealthRegenAmp()
		end
	end
	return regen_increase
end

-- Spell power
function CDOTA_BaseNPC:GetSpellPower()

	-- If this is not a hero, do nothing
	if not self:IsHero() then
		return 0
	end

	-- Adjust base spell power based on current intelligence
	local spell_power = self:GetIntellect() / 14

	-- Mega Treads increase spell power from intelligence by 30%
	if self:HasModifier("modifier_imba_mega_treads_stat_multiplier_02") then
		spell_power = self:GetIntellect() * 0.093
	end

	-- Fetch spell power from modifiers
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellAmplify_Percentage then
			spell_power = spell_power + parent_modifier:GetModifierSpellAmplify_Percentage()
		end
	end

	-- Return current spell power
	return spell_power
end

-- Cooldown reduction
function CDOTA_BaseNPC:GetCooldownReduction()

	-- If this is not a hero, do nothing
	if not self:IsRealHero() then
		return 0
	end

	-- Fetch cooldown reduction from modifiers
	local cooldown_reduction = 0
	local nonstacking_reduction = 0
	local stacking_reduction = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Nonstacking reduction
		if parent_modifier.GetCustomCooldownReduction then
			nonstacking_reduction = math.max(nonstacking_reduction, parent_modifier:GetCustomCooldownReduction())
		end

		-- Stacking reduction
		if parent_modifier.GetCustomCooldownReductionStacking then
			stacking_reduction = 100 - (100 - stacking_reduction) * (100 - parent_modifier:GetCustomCooldownReductionStacking()) * 0.01
		end
	end

	-- Calculate actual cooldown reduction
	cooldown_reduction = 100 - (100 - nonstacking_reduction) * (100 - stacking_reduction) * 0.01

	-- Return current cooldown reduction
	return cooldown_reduction
end

-- Calculate physical damage post reduction
function CDOTA_BaseNPC:GetPhysicalArmorReduction()
	local armornpc = self:GetPhysicalArmorValue(false)
	local armor_reduction = 1 - (0.06 * armornpc) / (1 + (0.06 * math.abs(armornpc)))
	armor_reduction = 100 - (armor_reduction * 100)
	return armor_reduction
end

function GetReductionFromArmor(armor)
	local m = 0.06 * armor
	return 100 * (1 - m/(1+math.abs(m)))
end

function CalculateReductionFromArmor_Percentage(armorOffset, armor)
	return -GetReductionFromArmor(armor) + GetReductionFromArmor(armorOffset)
end

-- Physical damage block
function CDOTA_BaseNPC:GetDamageBlock()

	-- Fetch damage block from custom modifiers
	local damage_block = 0
	local unique_damage_block = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Vanguard-based damage block does not stack
		if parent_modifier.GetCustomDamageBlockUnique then
			unique_damage_block = math.max(unique_damage_block, parent_modifier:GetCustomDamageBlockUnique())
		end

		-- Stack all other sources of damage block
		if parent_modifier.GetCustomDamageBlock then
			damage_block = damage_block + parent_modifier:GetCustomDamageBlock()
		end
	end

	-- Calculate total damage block
	damage_block = damage_block + unique_damage_block

	-- Ranged attackers only benefit from part of the damage block
	if self:IsRangedAttacker() then
		return 0.6 * damage_block
	else
		return damage_block
	end
end

function GameMode:OnLoadTop(list,topnum)
    if topnum == 1 then
        PlaysTopList = {}
    end
    if topnum == 2 then
        WinsTopList = {}
    end
    if topnum == 3 then
        HardWinsTopList = {}
    end
    if list[1] ~= nil then
        for i=1,#list do
            local id = ""
            local col = ""
            local locstr = ""
            for n=1,string.len(list[i]) do
                if string.char(string.byte(list[i], n)) ~= nil then
                    if string.char(string.byte(list[i], n)) == "-" then
                        id = locstr
                        locstr = ""
                    else
                        locstr = locstr .. string.char(string.byte(list[i], n))
                     end
                end
            end
            col = locstr
            local kv =
            {
                id = id,
                col = col
            }
            if topnum == 1 then
                table.insert(PlaysTopList,kv)
            end
            if topnum == 2 then
                table.insert(WinsTopList,kv)
            end
            if topnum == 3 then
                table.insert(HardWinsTopList,kv)
            end
        end
    end
    GameMode:UpdateTops()
end

function GameMode:UpdateProfiles(data)
    if data == nil or data.PlayerID == nil then return end
    GameMode:Levels(data)
    GameMode:NeedSteamIds(data)
    local pplc = PlayerResource:GetPlayerCount()
    for i=0,pplc-1 do
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(data.PlayerID), "MyProfileInfo", MyProfileArray[i])
    end
end

function GameMode:UpdateTops()
    print("UpdateTops")
    CustomGameEventManager:Send_ServerToAllClients( "UpdateTopPlays", PlaysTopList)
    CustomGameEventManager:Send_ServerToAllClients( "UpdateTopWins", WinsTopList)
    CustomGameEventManager:Send_ServerToAllClients( "UpdateTopHardWins", HardWinsTopList)
end

function GameMode:Levels(data)
    if data == nil or data.PlayerID == nil then return end
    local hero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    local lvl_item_corrupting_blade = 0
    local lvl_item_glimmerdark_shield = 0
    local lvl_item_guardian_shell = 0
    local lvl_item_dredged_trident = 0
    local lvl_item_oblivions_locket = 0
    local lvl_item_ambient_sorcery = 0
    local lvl_item_wand_of_the_brine = 0
    local lvl_item_seal_0 = 0
    if hero then
        if hero.lvl_item_corrupting_blade ~= nil then
            lvl_item_corrupting_blade = hero.lvl_item_corrupting_blade
        end
        if hero.lvl_item_glimmerdark_shield ~= nil then
            lvl_item_glimmerdark_shield = hero.lvl_item_glimmerdark_shield
        end
        if hero.lvl_item_guardian_shell ~= nil then
            lvl_item_guardian_shell = hero.lvl_item_guardian_shell
        end
        if hero.lvl_item_dredged_trident ~= nil then
            lvl_item_dredged_trident = hero.lvl_item_dredged_trident
        end
        if hero.lvl_item_oblivions_locket ~= nil then
            lvl_item_oblivions_locket = hero.lvl_item_oblivions_locket
        end
        if hero.lvl_item_ambient_sorcery ~= nil then
            lvl_item_ambient_sorcery = hero.lvl_item_ambient_sorcery
        end
        if hero.lvl_item_wand_of_the_brine ~= nil then
            lvl_item_wand_of_the_brine = hero.lvl_item_wand_of_the_brine
        end
        if hero.lvl_item_wand_of_the_brine ~= nil then
            lvl_item_seal_0 = hero.lvl_item_seal_0
        end
        local myvalue = {
            data.PlayerID,
            lvl_item_corrupting_blade,
            lvl_item_glimmerdark_shield,
            lvl_item_guardian_shell,
            lvl_item_dredged_trident,
            lvl_item_oblivions_locket,
            lvl_item_ambient_sorcery,
            lvl_item_wand_of_the_brine,
            lvl_item_seal_0,
            hero.rsinv,
            hero.rsp,
            hero.rsslots,
            hero.rssaves,
            hero.sealcolor,
            hero.sealcolors
        }
        CustomGameEventManager:Send_ServerToAllClients( "My_lvl", myvalue)
    end
    CustomGameEventManager:Send_ServerToAllClients( "My_lvl", myvalue)
end

--pointvtbl = {
--false,
--false,
--false,
--false,
--false
--}
--function GameMode:SetPointV(num, pointv)
--    pointvtbl[num] = pointv
--    local allok = true
--    for i=1,5 do
--        if pointvtbl[i] == false then
--            allok = false
--        end
--    end
--    if allok == true and PlayerResource:GetPlayerCount() == 5 then
--        local heroes = GetAllRealHeroes()
--        local unit = nil
--        local entts = Entities:FindAllByName("npc_dota_creature")
--        for i=1, #entts do
--            if entts[i]:GetUnitLabel() == "npc_dota_gold_spirit" then
--                unit = entts[i]
--            end
--        end
--        for i=1, #heroes do
--            local info = {
--                Target = unit,
--                Source = heroes[i],
--                Ability = nil,
--                EffectName = "particles/units/heroes/hero_dark_willow/dark_willow_base_attack.vpcf",
--                iMoveSpeed = 1600,
--            }
--            ProjectileManager:CreateTrackingProjectile( info )
--        end
--        Timers:CreateTimer(1.25, function()
--            GameMode:StartEndRounds()
--            pointvtbl = {
--            false,
--            false,
--            false,
--            false,
--            false
--            }
--            local pointents = GameMode:GetPointEnts()
--            for i=1,#pointents do
--                if pointents[i] ~= caster then
--                    pointents[i]:RemoveSelf()
--                end
--            end
--        end)
--    end
--end

LinkLuaModifier( "part_mod", "modifiers/parts/part_mod", LUA_MODIFIER_MOTION_NONE )

function GameMode:SelectPart(info)
    if info.offp == 0 then
        local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(info.PlayerID))
        if parts ~= nil then
            if parts[info.part] ~= "nill" and parts[info.part] ~= nil then
        
                local arr = {
                    info.PlayerID,
                    PlayerResource:GetPlayerName(info.PlayerID),
                    info.part,
                    PlayerResource:GetSelectedHeroName(info.PlayerID)
                }
                
                -- local gameEvent = {}
                -- gameEvent["player_id"] = info.PlayerID
                -- gameEvent["teamnumber"] = -1
                -- gameEvent["locstring_value"] = info.part--"#DOTA_Tooltip_Ability_" .. ability:GetAbilityName()
                -- gameEvent["message"] = "#Combat_Message_use_ultimate"
                -- FireGameEvent( "dota_combat_event_message", gameEvent )

                CustomGameEventManager:Send_ServerToAllClients( "UpdateParticlesUI", arr)
                PlayerResource:GetSelectedHeroEntity(info.PlayerID):RemoveModifierByName("part_mod")
                PlayerResource:GetSelectedHeroEntity(info.PlayerID):AddNewModifier(PlayerResource:GetSelectedHeroEntity(info.PlayerID), PlayerResource:GetSelectedHeroEntity(info.PlayerID), "part_mod", {part = info.part})
            end
        end
    else
        PlayerResource:GetSelectedHeroEntity(info.PlayerID):RemoveModifierByName("part_mod")
    end
end

function GameMode:ExecuteOrderFilter( filterTable )
	--[[
	for k, v in pairs( filterTable ) do
		print("EO: " .. k .. " " .. tostring(v) )
	end
	]]

	local orderType = filterTable["order_type"]
	local target = nil
	local playerId = filterTable.issuer_player_id_const
	local ability = EntIndexToHScript(filterTable.entindex_ability)
	local unit = nil

	if filterTable.units ~= nil then
		if filterTable.units["0"] ~= nil then
			unit = EntIndexToHScript(filterTable.units["0"])
		end
	end
	if filterTable.entindex_target and filterTable.entindex_target ~= 0 then
		target = EntIndexToHScript(filterTable.entindex_target)
	end

	if orderType == DOTA_UNIT_ORDER_CAST_TARGET then
		if ability and target and unit then
			if PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(), unit:GetPlayerOwnerID()) and (ability:GetName() == "oracle_fates_edict" or ability:GetName() == "oracle_purifying_flames" or ability:GetName() == "earth_spirit_boulder_smash" or ability:GetName() == "earth_spirit_geomagnetic_grip" or ability:GetName() == "earth_spirit_petrify" or ability:GetName() == "troll_warlord_battle_trance") then
				DisplayError(unit:GetPlayerOwnerID(), "dota_hud_error_target_has_disable_help")
				return false
			end
		end
	end
	return true
end

function GameMode:DamageFilter( event )
    --print( '********damage event************' )
    -- for k, v in pairs(event) do
    --     print("DamageFilter: ",k, " ==> ", v)
    -- end
    if not _G.shadow_arena then
        return true
    end
    local attacker = EntIndexToHScript(event.entindex_attacker_const)
    local victim = EntIndexToHScript(event.entindex_victim_const)
    if not attacker or not victim or attacker == victim or attacker:GetTeam() == victim:GetTeam() then
        return true
    end
    -- local ability = nil
    -- if event.entindex_inflictor_const then --if there is no inflictor key then it was an auto attack
    --     ability = EntIndexToHScript(event.entindex_inflictor_const)
    -- end

    local multiple = 1
    if attacker:GetTeam() == DOTA_TEAM_GOODGUYS then
        local razn = victim:GetLevel() - _G.GAME_ROUND
        if razn >= 0 then
            multiple = 1 + (razn) * 0.3
        else
            for i=1, 0-razn do
                multiple = multiple * 0.88
            end
        end
    else
        local razn = attacker:GetLevel() - _G.GAME_ROUND
        if razn >= 0 then
            for i=1, razn+1 do
                multiple = multiple * 0.85
            end
        else
            multiple = 1 + (razn) * -0.3
        end
    end

    --print('DamageFilter: victim resistances:', resist)
    local newdamage = event.damage * multiple
    if newdamage <= 0 then
        --print('DamageFilter: Damage is 0')
        return false
    end
    --print('DamageFilter: Dealing damage ', newdamage)
    event.damage = newdamage
    return true
end