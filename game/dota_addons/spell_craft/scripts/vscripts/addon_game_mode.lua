debug.oldTraceback = debug.oldTraceback or debug.traceback
debug.traceback = function()
	local result = debug.oldTraceback()
	-- print(result)--CustomGameEventManager:Send_ServerToAllClients("DebugMessage", { msg = result })
    local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/luadebug.php")
    req:SetHTTPRequestGetOrPostParameter("debug", result)
    req:Send(function(req_result)
        print(req_result.Body)
    end)
	return result
end

-- if IsClient() then
--     print("IsClient()")
-- end

--[[
	Basic Barebones
]]

-- Required files to be visible from anywhere
require( 'timers' )
require( 'barebones' )
require( 'quest_system')
require( 'pets')
require( 'add_zones')
require( 'libraries/animations' )
require( 'libraries/physics' )
require( 'libraries/code' )
require( 'libraries/utils' )

_G.GAME_ROUND = 0
time_ = 0
ROUND_UNITS =
{
    -------1
    5,
    1,
    nil,
    nil,
    nil,
    -------2
    10,
    10,
    1,
    nil,
    nil,
    -------3
    10,
    1,
    nil,
    nil,
    nil,
    -------4
    2,
    1,
    nil,
    nil,
    nil,
    -------5
    1,
    nil,
    nil,
    nil,
    nil,
    -------6
    3,
    8,
    1,
    nil,
    nil,
    -------7
    1,
    5,
    nil,
    nil,
    nil,
    -------8
    1,
    7,
    2,
    nil,
    nil,
    -------9
    1,
    6,
    nil,
    nil,
    nil,
    -------10
    1,
    nil,
    nil,
    nil,
    nil,
    -------11
    9,
    1,
    nil,
    nil,
    nil,
    -------12
    3,
    1,
    6,
    nil,
    nil,
    -------13
    1,
    6,
    nil,
    nil,
    nil,
    -------14
    7,
    1,
    nil,
    nil,
    nil,
    -------15
    1,
    nil,
    nil,
    nil,
    nil,
    -------16
    7,
    1,
    nil,
    nil,
    nil,
    -------17
    1,
    9,
    nil,
    nil,
    nil,
    -------18
    1,
    9,
    nil,
    nil,
    nil,
    -------19
    1,
    9,
    nil,
    nil,
    nil,
    -------20
    1,
    nil,
    nil,
    nil,
    nil,
    -------21
    8,
    1,
    1,
    nil,
    nil,
    -------22
    4,
    1,
    1,
    nil,
    nil,
    -------23
    5,
    1,
    1,
    nil,
    nil,
    -------24
    5,
    1,
    1,
    nil,
    nil,
    -------25
    1,
    nil,
    nil,
    nil,
    nil,
    -------26
    8,
    1,
    1,
    nil,
    nil,
    -------27
    8,
    1,
    1,
    nil,
    nil,
    -------28
    5,
    2,
    nil,
    nil,
    nil,
    -------29
    4,
    1,
    1,
    nil,
    nil,
    -------30
    1,
    nil,
    nil,
    nil,
    nil,
    -------31
    1,
    1,
    2,
    6,
    nil,
    -------32
    1,
    1,
    6,
    nil,
    nil,
    -------33
    1,
    1,
    4,
    nil,
    nil,
    -------34
    1,
    1,
    8,
    nil,
    nil,
    -------35
    1,
    nil,
    nil,
    nil,
    nil,
    -------36
    1,
    5,
    nil,
    nil,
    nil,
    -------37
    1,
    5,
    nil,
    nil,
    nil,
    -------38
    1,
    4,
    nil,
    nil,
    nil,
    -------39
    1,
    9,
    nil,
    nil,
    nil,
    -------40
    1,
    nil,
    nil,
    nil,
    nil,
    -------41
    1,
    5,
    nil,
    nil,
    nil,
    -------42
    1,
    4,
    nil,
    nil,
    nil,
    -------43
    5,
    2,
    nil,
    nil,
    nil,
    -------44
    1,
    5,
    nil,
    nil,
    nil,
    -------45
    1,
    nil,
    nil,
    nil,
    nil,
    -------46
    1,
    4,
    nil,
    nil,
    nil,
    -------47
    1,
    9,
    nil,
    nil,
    nil,
    -------48
    1,
    7,
    nil,
    nil,
    nil,
    -------49
    1,
    3,
    6,
    nil,
    nil,
    -------50
    1,
    nil,
    nil,
    nil,
    nil
    }
    UNITS_NAMES = 
    {
    ---------1
    "npc_dota_custom_creep_1_1",
    "npc_dota_custom_creep_1_2",
    nil,
    nil,
    nil,
    ----------2
    "npc_dota_custom_creep_2_1",
    "npc_dota_custom_creep_2_2",
    "npc_dota_custom_creep_2_3",
    nil,
    nil,
    ----------3
    "npc_dota_custom_creep_3_1",
    "npc_dota_custom_creep_3_2",
    nil,
    nil,
    nil,
    -----------4
    "npc_dota_custom_creep_4_1",
    "npc_dota_custom_creep_4_2",
    nil,
    nil,
    nil,
    -----------5
    "npc_dota_custom_creep_5_1",
    nil,
    nil,
    nil,
    nil,
    -----------6
    "npc_dota_custom_creep_6_1",
    "npc_dota_custom_creep_6_2",
    "npc_dota_custom_creep_6_3",
    nil,
    nil,
    -----------7
    "npc_dota_custom_creep_7_1",
    "npc_dota_custom_creep_7_2",
    nil,
    nil,
    nil,
    -----------8
    "npc_dota_custom_creep_8_1",
    "npc_dota_custom_creep_8_2",
    "npc_dota_custom_creep_8_3",
    nil,
    nil,
    -----------9
    "npc_dota_custom_creep_9_1",
    "npc_dota_custom_creep_9_3",
    nil,
    nil,
    nil,
    -----------10
    "npc_dota_custom_creep_10_1",
    nil,
    nil,
    nil,
    nil,
    -----------11
    "npc_dota_custom_creep_11_1",
    "npc_dota_custom_creep_11_2",
    nil,
    nil,
    nil,
    -----------12
    "npc_dota_custom_creep_12_1",
    "npc_dota_custom_creep_12_2",
    "npc_dota_custom_creep_12_3",
    nil,
    nil,
    -----------13
    "npc_dota_custom_creep_13_1",
    "npc_dota_custom_creep_13_2",
    nil,
    nil,
    nil,
    -----------14
    "npc_dota_custom_creep_14_1",
    "npc_dota_custom_creep_14_2",
    nil,
    nil,
    nil,
    -----------15
    "npc_dota_custom_creep_15_1",
    nil,
    nil,
    nil,
    nil,
    -----------16
    "npc_dota_custom_creep_16_1",
    "npc_dota_custom_creep_16_2",
    nil,
    nil,
    nil,
    -----------17
    "npc_dota_custom_creep_17_1",
    "npc_dota_custom_creep_17_2",
    nil,
    nil,
    nil,
    -----------18
    "npc_dota_custom_creep_18_1",
    "npc_dota_custom_creep_18_2",
    nil,
    nil,
    nil,
    -----------19
    "npc_dota_custom_creep_19_1",
    "npc_dota_custom_creep_19_2",
    nil,
    nil,
    nil,
    -----------20
    "npc_dota_custom_creep_20_1",
    nil,
    nil,
    nil,
    nil,
    -----------21
    "npc_dota_custom_creep_21_1",
    "npc_dota_custom_creep_21_2",
    "npc_dota_custom_creep_21_3",
    nil,
    nil,
    -----------22
    "npc_dota_custom_creep_22_1",
    "npc_dota_custom_creep_22_2",
    "npc_dota_custom_creep_22_3",
    nil,
    nil,
    -----------23
    "npc_dota_custom_creep_23_1",
    "npc_dota_custom_creep_23_2",
    "npc_dota_custom_creep_23_3",
    nil,
    nil,
    -----------24
    "npc_dota_custom_creep_24_1",
    "npc_dota_custom_creep_24_2",
    "npc_dota_custom_creep_24_3",
    nil,
    nil,
    -----------25
    "npc_dota_custom_creep_25_1",
    nil,
    nil,
    nil,
    nil,
    -----------26
    "npc_dota_custom_creep_26_1",
    "npc_dota_custom_creep_26_2",
    "npc_dota_custom_creep_26_3",
    nil,
    nil,
    -----------27
    "npc_dota_custom_creep_27_1",
    "npc_dota_custom_creep_27_2",
    "npc_dota_custom_creep_27_3",
    nil,
    nil,
    -----------28
    "npc_dota_custom_creep_28_1",
    "npc_dota_custom_creep_28_3",
    nil,
    nil,
    nil,
    -----------29
    "npc_dota_custom_creep_29_1",
    "npc_dota_custom_creep_29_1_1",
    "npc_dota_custom_creep_29_1_2",
    nil,
    nil,
    -----------30
    "npc_dota_custom_creep_30_1",
    nil,
    nil,
    nil,
    nil,
    -----------31
    "npc_dota_custom_creep_31_1",
    "npc_dota_custom_creep_31_2",
    "npc_dota_custom_creep_31_3",
    "npc_dota_custom_creep_31_4",
    nil,
    -----------32
    "npc_dota_custom_creep_32_1",
    "npc_dota_custom_creep_32_2",
    "npc_dota_custom_creep_32_3",
    nil,
    nil,
    -----------33
    "npc_dota_custom_creep_33_1",
    "npc_dota_custom_creep_33_2",
    "npc_dota_custom_creep_33_3",
    nil,
    nil,
    -----------34
    "npc_dota_custom_creep_34_1",
    "npc_dota_custom_creep_34_2",
    "npc_dota_custom_creep_34_3",
    nil,
    nil,
    -----------35
    "npc_dota_custom_creep_35_1",
    nil,
    nil,
    nil,
    nil,
    -----------36
    "npc_dota_custom_creep_36_1",
    "npc_dota_custom_creep_36_2",
    nil,
    nil,
    nil,
    -----------37
    "npc_dota_custom_creep_37_1",
    "npc_dota_custom_creep_37_2",
    nil,
    nil,
    nil,
    -----------38
    "npc_dota_custom_creep_38_1",
    "npc_dota_custom_creep_38_2",
    nil,
    nil,
    nil,
    -----------39
    "npc_dota_custom_creep_39_1",
    "npc_dota_custom_creep_39_2",
    nil,
    nil,
    nil,
    -----------40
    "npc_dota_custom_creep_40_1",
    nil,
    nil,
    nil,
    nil,
    -----------41
    "npc_dota_custom_creep_41_1",
    "npc_dota_custom_creep_41_2",
    nil,
    nil,
    nil,
    -----------42
    "npc_dota_custom_creep_42_1",
    "npc_dota_custom_creep_42_2",
    nil,
    nil,
    nil,
    -----------43
    "npc_dota_custom_creep_43_1",
    "npc_dota_custom_creep_43_2",
    nil,
    nil,
    nil,
    -----------44
    "npc_dota_custom_creep_44_1",
    "npc_dota_custom_creep_44_2",
    nil,
    nil,
    nil,
    -----------45
    "npc_dota_custom_creep_45_1",
    nil,
    nil,
    nil,
    nil,
    -----------46
    "npc_dota_custom_creep_46_1",
    "npc_dota_custom_creep_46_2",
    nil,
    nil,
    nil,
    -----------47
    "npc_dota_custom_creep_47_1",
    "npc_dota_custom_creep_47_2",
    nil,
    nil,
    nil,
    -----------48
    "npc_dota_custom_creep_48_1",
    "npc_dota_custom_creep_48_2",
    nil,
    nil,
    nil,
    -----------49
    "npc_dota_custom_creep_49_1",
    "npc_dota_custom_creep_49_2",
    "npc_dota_custom_creep_49_3",
    nil,
    nil,
    -----------50
    "npc_dota_custom_creep_50_1",
    nil,
    nil,
    nil,
    nil
}


function Precache( context )
	-- NOTE: IT IS RECOMMENDED TO USE A MINIMAL AMOUNT OF LUA PRECACHING, AND A MAXIMAL AMOUNT OF DATADRIVEN PRECACHING.
	-- Precaching guide: https://moddota.com/forums/discussion/119/precache-fixing-and-avoiding-issues

	--[[
	This function is used to precache resources/units/items/abilities that will be needed
	for sure in your game and that cannot or should not be precached asynchronously or 
	after the game loads.
	See GameMode:PostLoadPrecache() in barebones.lua for more information
	]]

	print("[BAREBONES] Performing pre-load precache")
    
    PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_desolation/sf_base_attack_desolation_fire_arcana.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_ancient_apparition/ice_temp.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/ti7/teleport_start_ti7_spin_water.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcff", context)
    PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_stone.vpcf", context)
    PrecacheResource("particle", "particles/items_fx/ironwood_tree.vpcf", context)
    PrecacheResource("particle", "particles/my_air_part.vpcf", context)
    PrecacheResource("particle", "particles/my_courier_trail_polycount_01.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_enigma/enigma_ambient_body_fallback_low.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/lina/lina_ti6/lina_ti6_ambient_ground_dust.vpcf", context)
    PrecacheResource("particle", "particles/vr/player_light_godray.vpcf", context)
    PrecacheResource("particle", "particles/items2_fx/urn_of_shadows_orbs.vpcf", context)
    PrecacheResource("particle", "particles/my_pugna_netherblast_pre.vpcf", context)
    PrecacheResource("particle", "particles/my_pugna_netherblast.vpcf", context)
    PrecacheResource("particle", "particles/my_doom_bringer_doom_ring.vpcf", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_custom.vsndevts", context )
    PrecacheResource("particle", "particles/generic_gameplay/lasthit_coins_local.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_undying/undying_tnt_wlk_golem.vpcf", context)
    PrecacheResource("particle", "particles/items3_fx/fish_bones_active.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_wisp/wisp_base_attack.vpcf", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_centaur", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_weaver", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_weaver.vsndevts", context )
    PrecacheResource("particle", "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf", context)
    PrecacheResource("particle_folder", "particles/units/heroes/hero_ursa", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context )
    PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", context)
    PrecacheResource("particle_folder", "particles/units/heroes/hero_lone_druid", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_elder_titan", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_phantom_assassin", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_lich", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_silencer", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_alchemist", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_phoenix", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_slark", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_terrorblade", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_drow", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_axe", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_tiny", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_bloodseeker", context)
    PrecacheResource("particle_folder", "particles/econ/items/bloodseeker", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_nyx_assassin", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context )
    PrecacheResource("particle_folder", "particles/frostivus_gameplay", context)
    PrecacheResource("particle", "particles/econ/events/ti7/dagon_ti7.vpcf", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_medusa", context)
    PrecacheResource("particle_folder", "particles/econ/items/medusa/medusa_daughters", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_zuus", context)
    PrecacheResource("particle_folder", "particles/units/heroes/hero_zeus", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_huskar", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_chaos_knight", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_techies", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_tinker", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_faceless_void", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_spectre", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_keeper_of_the_light", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_kunkka", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_medusa", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_enchantress", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_clinkz", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_earth_spirit", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_necrolyte", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_luna", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_obsidian_destroyer", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_meepo", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_abaddon", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_life_stealer", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context )
    PrecacheResource("particle_folder", "particles/units/heroes/hero_venomancer", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context )
    
    PrecacheResource("particle_folder", "particles/my_new", context)
    --PrecacheResource("particle", "particles/rain_fx/econ_snow.vpcf", context)
    PrecacheResource("particle", "particles/my_wisp_guardian_.vpcf", context)
    PrecacheResource("particle", "particles/my_wisp_base_attack.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_emp_bloom.vpcf", context)
    PrecacheResource("particle", "particles/my_magnataur_shockwave.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_death_model.vpcf", context)
    
    PrecacheResource("particle", "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_hermit_crab/hermit_crab_skady_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient_lvl4.vpcf", context)
    PrecacheResource("particle", "particles/dev/curlnoise_test.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_faceless_rex/cour_rex_ground_a.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/sniper/sniper_charlie/sniper_shrapnel_charlie_ground.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_purple/courier_greevil_purple_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_yellow/courier_greevil_yellow_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_2.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/ti8/ti8_hero_effect.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_detail.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_friend.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_monkey_king/monkey_king_disguise_smoke_top.vpcf", context)
    PrecacheResource("particle", "particles/traps/pendulum/blade_trails.vpcf", context)
    PrecacheResource("particle", "particles/traps/pendulum/wheel_scrape.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_windrun_combo.vpcf", context)
    PrecacheResource("particle", "particles/legendary_items/ice_staff.vpcf", context)
    
    PrecacheModel("models/items/juggernaut/armor_for_the_favorite_arms/armor_for_the_favorite_arms.vmdl", context)
    PrecacheModel("models/items/juggernaut/armor_for_the_favorite_back/armor_for_the_favorite_back.vmdl", context)
    PrecacheModel("models/items/juggernaut/armor_for_the_favorite_head/armor_for_the_favorite_head.vmdl", context)
    PrecacheModel("models/items/juggernaut/armor_for_the_favorite_legs/armor_for_the_favorite_legs.vmdl", context)
    PrecacheModel("models/items/juggernaut/armor_for_the_favorite_weapon/armor_for_the_favorite_weapon.vmdl", context)
    PrecacheResource("particle", "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_shoulder_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_eyes.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_body_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_weapon.vpcf", context)
    
    PrecacheModel("models/courier/baby_rosh/babyroshan_elemental.vmdl", context)
    PrecacheModel("models/items/courier/el_gato_beyond_the_summit/el_gato_beyond_the_summit.vmdl", context)
    
	--local precacheList = LoadKeyValues('scripts/npc/activelist.txt')
    --for hero, activated in pairs(precacheList) do
    --    if activated  == 1 then
	--		PrecacheUnitByNameSync(hero, context)
	--	end
    --end
    
	local precacheList = LoadKeyValues('scripts/npc/npc_units_custom.txt')
	for unit, info in pairs(precacheList) do
		PrecacheUnitByNameSync(unit, context)
	end
    
	local precacheList = LoadKeyValues('scripts/npc/npc_items_custom.txt')
	for item, info in pairs(precacheList) do
		PrecacheItemByNameSync(item, context)
	end
end

-- Create the game mode when we activate

function Activate()
	GameRules.GameMode = GameMode()
    GameRules.GameMode:InitGameMode()
end

--shop_en = true

--function GameMode:Check()
--    local shop = Entities:FindByName( nil, "shop_c")
--    if shop_en then
--        shop:Disable()
--        shop:Enable()
--    else
--        shop:Enable()
--        Timers:CreateTimer(0.001, function()
--            shop:Disable()
--        end)
--    end
--end

acc = {false,true,true,true,true}

function GameMode:Vote_Round(event)
    if event == nil or event.PlayerID == nil then return end
    local go = true
    
    CustomGameEventManager:Send_ServerToAllClients( "Update_Vote", {id = event.PlayerID})
    
    acc[event.PlayerID+1] = true
    
    for i=1,5 do
        if acc[i] == false then
            go = false
        end
    end
    
    if go == true then
        time_ = 60
        acc = {false,false,false,false,false}
    end
    
end
cheats = false

function GameMode:GetTimeToWave()
    return time_
end

--pointents = {}

random_wave_effects = {
    "modifier_slow_wave_effect",
    "modifier_min_armor_wave_effect",
    "modifier_miss_wave_effect"
}
for _, modname in pairs(random_wave_effects) do
    LinkLuaModifier( modname, "modifiers/wave_effect_mods", LUA_MODIFIER_MOTION_NONE )
end
function GameMode:OnGameInProgress()
    if time_ == 0 then
        local spawner_ent = Entities:FindByName( nil, "spawner")
        local point = Vector(0,0,0)
        if spawner_ent then
            point = spawner_ent:GetAbsOrigin()
        end
        --local waypoint = Entities:FindByName( nil, "way1")
        local return_time = 60  --время между волнами
        if GameRules:IsCheatMode() then
            cheats = true
        end

        time_ = 1

        local heroes = GetAllRealHeroes()
        for i=1, #heroes do
            if heroes[i].oldwd then
                if heroes[i].damage_schetchik then
                    heroes[i].nowwd = math.ceil(heroes[i].damage_schetchik - heroes[i].oldwd)
                    heroes[i].oldwd = math.ceil(heroes[i].damage_schetchik)
                else
                    heroes[i].oldwd = 0
                    heroes[i].nowwd = 0
                end
            else
                if heroes[i].damage_schetchik then
                    heroes[i].nowwd = math.ceil(heroes[i].damage_schetchik)
                    heroes[i].oldwd = math.ceil(heroes[i].damage_schetchik)
                else
                    heroes[i].oldwd = 0
                    heroes[i].nowwd = 0
                end
            end
        end

        for _, mod in pairs(_G.wave_effect_mods) do
            mod:Destroy()
        end
        _G.wave_effect_mods = {}

        RefreshPlayers()

        if (not _G.hardmode and _G.GAME_ROUND > 9 and RandomInt( 1, 9 ) == 1) or (_G.hardmode and RandomInt( 1, 7 ) == 1) then
            table.insert(_G.wave_effect_mods, _G.gold_spirit:AddNewModifier(_G.gold_spirit, nil, random_wave_effects[RandomInt(1, #random_wave_effects)], {}))
        end
        
        local maxdh = nil
        local maxdmg = -1
        local dlist = {}
        local myneedheroes = GetAllRealHeroes()
        local rest = #myneedheroes
        for i=1, #myneedheroes do
            maxdh = nil
            maxdmg = -1
            for n=1, rest do
                if myneedheroes[n] ~= nil then
                    if myneedheroes[n].nowwd > maxdmg then
                        maxdmg = myneedheroes[n].nowwd
                        maxdh = n
                    end
                end
            end
            table.insert(dlist,myneedheroes[maxdh])
            myneedheroes[maxdh] = nil
        end
        local nameslist = {}
        
        for i=1, 5 do
            if dlist[i] then
                table.insert(nameslist,dlist[i]:GetName())
                table.insert(nameslist,dlist[i].nowwd)
            else
                table.insert(nameslist,nil)
                table.insert(nameslist,nil)
            end
        end
        local rlist = {
            hero1=nameslist[1],
            damage1=nameslist[2],
            hero2=nameslist[3],
            damage2=nameslist[4],
            hero3=nameslist[5],
            damage3=nameslist[6],
            hero4=nameslist[7],
            damage4=nameslist[8],
            hero5=nameslist[9],
            damage5=nameslist[10]
        }
        CustomGameEventManager:Send_ServerToAllClients( "Open_DamageTop", rlist)
        
    --if _G.GAME_ROUND < 51 then
        local skip_autovote = false
        
        acc = {true,true,true,true,true}
        for i=1, #heroes do
            acc[i] = false
        end
        CustomGameEventManager:Send_ServerToAllClients( "Display_RoundVote", { count = #heroes })
        
        for n=1, 4 do
            if RandomInt( 1, 4 ) == 1 then
                --spawn item
                local portal_point = Entities:FindByName( nil, "portal_point_"..n):GetAbsOrigin()
                local item = CreateItem("item_portal", nil, nil)
                table.insert(_G.portal_items, item)
                table.insert(_G.portal_item_drops, CreateItemOnPositionSync( portal_point, item ))
                -- skip_autovote = true
            end
        end

        for n=1, #heroes do
            if PlayerResource:GetConnectionState(heroes[n]:GetPlayerOwnerID()) ~= 2 then
                GameMode:Vote_Round({PlayerID = heroes[n]:GetPlayerOwnerID()})
            end
            if not skip_autovote and heroes[n].autovote ~= nil and heroes[n].autovote == 1 then
                GameMode:Vote_Round({PlayerID = heroes[n]:GetPlayerOwnerID()})
            end
        end
            
        QuestSystem:CreateQuest("PrepTime","#QuestPanel",1,return_time,nil,_G.GAME_ROUND + 1)
            
        Timers:CreateTimer(1, function()
            if _G.shadow_arena then
                time_ = 0
                return
            end
            if time_ <= return_time then
                QuestSystem:RefreshQuest("PrepTime",time_,return_time,_G.GAME_ROUND + 1)
                time_ = time_ + 1
                return 1
            end

            AddZones:EndAllZones()

            RefreshPlayers()
            local plc = PlayerResource:GetPlayerCount()
            for i=0,plc-1 do
                local hero = PlayerResource:GetSelectedHeroEntity(i)
                if hero and hero.zone ~= "main_zone" then
                    TeleportPlayerToZone(i, "main_zone")
                end
            end

            for k, drop in pairs(_G.portal_item_drops) do
                if drop then UTIL_Remove( drop ) end
            end
            _G.portal_item_drops = {}
            for k, item in pairs(_G.portal_items) do
                if item then UTIL_Remove( item ) end
            end
            _G.portal_items = {}

            time_ = 0
            
            QuestSystem:DelQuest("PrepTime")
            
            CustomGameEventManager:Send_ServerToAllClients( "Close_DamageTop", {})
            CustomGameEventManager:Send_ServerToAllClients( "Close_RoundVote", {})
            
            _G.GAME_ROUND = _G.GAME_ROUND + 1
            
            CustomNetTables:SetTableValue("Hero_Stats","wave",{_G.GAME_ROUND})
            
            --print("Wave №" .. _G.GAME_ROUND)
            --local waveinfo = {
            --    message = "Wave №" .. _G.GAME_ROUND,
            --    duration  = 3
            --}
            --FireGameEvent("show_center_message",waveinfo)
            EmitGlobalSound("Tutorial.Quest.complete_01")
            for i=1, 5 do
                local num = i + (5*(_G.GAME_ROUND-1))
                if UNITS_NAMES[num] ~= nil then
                    for i=1, ROUND_UNITS[num] do
                        local unit = CreateUnitByName( UNITS_NAMES[num], point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
                        local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti4/blink_dagger_end_ti4.vpcf", PATTACH_ABSORIGIN, unit )
                        ParticleManager:ReleaseParticleIndex( pfx )
                        --unit:SetInitialGoalEntity( waypoint )
                        if _G.hardmode then
                            if UNITS_NAMES[num] == "npc_dota_custom_creep_4_1" or UNITS_NAMES[num] == "npc_dota_custom_creep_4_2" then
                                unit:AddItemByName("item_fire_earth_water")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_11_1" or UNITS_NAMES[num] == "npc_dota_custom_creep_11_2" then
                                unit:AddItemByName("item_ice_fire_earth")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_14_1" or UNITS_NAMES[num] == "npc_dota_custom_creep_14_2" then
                                unit:AddItemByName("item_earth_shadow_life_2")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_15_1" then
                                unit:AddItemByName("item_fire_core")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_16_1" or UNITS_NAMES[num] == "npc_dota_custom_creep_16_2" then
                                unit:AddItemByName("item_butterfly")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_17_2" then
                                unit:AddItemByName("item_energy_fire_void")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_19_1" or UNITS_NAMES[num] == "npc_dota_custom_creep_19_2" then
                                unit:AddItemByName("item_hammer_of_god")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_20_1" then
                                unit:AddItemByName("item_fire_radiance")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_21_1" or UNITS_NAMES[num] == "npc_dota_custom_creep_21_2" or UNITS_NAMES[num] == "npc_dota_custom_creep_21_3" then
                                unit:AddItemByName("item_echo_sabre")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_22_1" or UNITS_NAMES[num] == "npc_dota_custom_creep_22_2" or UNITS_NAMES[num] == "npc_dota_custom_creep_22_3" then
                                unit:AddItemByName("item_earth_s_and_y")
                            end if UNITS_NAMES[num] == "npc_dota_custom_creep_25_1" then
                                unit:AddItemByName("item_energy_core")
							end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_5_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_10_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_15_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_20_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_24_3" then unit:AddItemByName("item_maelstrom") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_24_3" then unit:AddAbility("passive_ros") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_25_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_28_3" then unit:AddAbility("desire_of_life") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_30_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_35_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_40_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_43_2" then unit:AddItemByName("item_fire_core") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_44_1" or UNITS_NAMES[num] == "npc_dota_custom_creep_44_2" then unit:AddItemByName("item_lesser_crit") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_45_1" then unit:AddItemByName("item_titan_chunk") end
							if UNITS_NAMES[num] == "npc_dota_custom_creep_50_1" then unit:AddItemByName("item_titan_chunk") end
                        end
                    end
                end
            end
            
            local heroes = GetAllRealHeroes()
            for i=1, #heroes do
                if PlayerResource:GetConnectionState(heroes[i]:GetPlayerOwnerID()) == 2 then
                    local modifs = heroes[i]:FindAllModifiers()
                    for b=1, #modifs do
                        if modifs[b]:GetAbility() ~= nil then
                            if modifs[b].needupwawe then
                                modifs[b]:OnWaweChange(_G.GAME_ROUND)
                            end
                        end
                    end
                end
            end
        end)
    --else
    --    if _G.GAME_ROUND == 35 then
    --        Timers:CreateTimer(1, function()
    --            CustomGameEventManager:Send_ServerToAllClients( "endswaves", {})
    --        end)
    --    end
    --    for i=1, 5 do
    --        local point = Entities:FindByName( nil, "point"..i):GetAbsOrigin()
    --        local unit = CreateUnitByName( "npc_dota_my_point", point, true, nil, nil, DOTA_TEAM_GOODGUYS )
    --        unit:SetBaseDamageMin(i)
    --        table.insert(pointents, unit)
    --    end
    --end
    end
end

function GameMode:_Stats(iswin)
    local plc = PlayerResource:GetPlayerCount()
    if not GameRules:IsCheatMode() and _G.GAME_ROUND ~= 0 and cheats == false and GameRules:GetDOTATime(false,false) > 35 and plc > 0 then
        local req = CreateHTTPRequestScriptVM( "POST", GameMode.gjfll2 .. "/data.php")
        req:SetHTTPRequestGetOrPostParameter("v", _G.DedicatedServerKey)
        if iswin ~= nil then
            req:SetHTTPRequestGetOrPostParameter("test", "-1" .. iswin)
        else
            req:SetHTTPRequestGetOrPostParameter("test", tostring(_G.GAME_ROUND))
        end
        req:SetHTTPRequestGetOrPostParameter("players", tostring(plc))
        req:SetHTTPRequestGetOrPostParameter("time", tostring(math.floor(GameRules:GetDOTATime(false,false))))
        if _G.hardmode == true then
            req:SetHTTPRequestGetOrPostParameter("hardmode", "true")
        else
            req:SetHTTPRequestGetOrPostParameter("hardmode", "false")
        end
        -- if _G.userelic == true then
        --     req:SetHTTPRequestGetOrPostParameter("userelic", "true")
        -- else
        --     req:SetHTTPRequestGetOrPostParameter("userelic", "false")
        -- end
        for i=0,plc-1 do
            if PlayerResource:GetConnectionState(i) == 2 then
                req:SetHTTPRequestGetOrPostParameter("hero" .. i+1,tostring(PlayerResource:GetSelectedHeroID(i)))
                req:SetHTTPRequestGetOrPostParameter("id" .. i+1, tostring(PlayerResource:GetSteamID(i)))
                -- if iswin ~= nil then
                --     local hero = PlayerResource:GetSelectedHeroEntity( i )
                --     req:SetHTTPRequestGetOrPostParameter("lvl" .. i+1, tostring(hero:GetLevel()))
                --     req:SetHTTPRequestGetOrPostParameter("gold" .. i+1, tostring(hero:GetGold()))
                --     for u=0, 9, 1 do
                --         local current_item = hero:GetItemInSlot(u)
                --         if current_item ~= nil then
                --             req:SetHTTPRequestGetOrPostParameter("item" .. i+1 .. "_" .. u+1, current_item:GetName())
                --         end
                --     end
                -- end
            end
        end
        req:Send(function(result)
            print(result.Body)
        end)
    end
end

function GameMode:CheckWearables(unit)
    if tostring(PlayerResource:GetSteamID(unit:GetPlayerID())) == "76561198112013738" then
        if unit:GetName() == "npc_dota_hero_juggernaut" then
            GameMode:RemoveAllWearables(unit)
            GameMode:AttachWearable(unit,"models/items/juggernaut/armor_for_the_favorite_arms/armor_for_the_favorite_arms.vmdl","particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_shoulder_ambient.vpcf")
            GameMode:AttachWearable(unit,"models/items/juggernaut/armor_for_the_favorite_back/armor_for_the_favorite_back.vmdl","particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_shoulder_ambient.vpcf")
            GameMode:AttachWearable(unit,"models/items/juggernaut/armor_for_the_favorite_head/armor_for_the_favorite_head.vmdl","particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_eyes.vpcf")
            GameMode:AttachWearable(unit,"models/items/juggernaut/armor_for_the_favorite_legs/armor_for_the_favorite_legs.vmdl","particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_body_ambient.vpcf")
            GameMode:AttachWearable(unit,"models/items/juggernaut/armor_for_the_favorite_weapon/armor_for_the_favorite_weapon.vmdl","particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_weapon.vpcf")
        end
        --if unit:GetName() == "npc_dota_hero_dazzle" then
        --    GameMode:RemoveAllWearables(unit)
        --    GameMode:AttachWearable(unit,"models/items/dazzle/darkclaw_acolyte_back/darkclaw_acolyte_back.vmdl","particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_ambient_head.vpcf")
        --    GameMode:AttachWearable(unit,"models/items/dazzle/darkclaw_acolyte_misc/darkclaw_acolyte_misc.vmdl",nil)
        --    GameMode:AttachWearable(unit,"models/items/dazzle/darkclaw_acolyte_legs/darkclaw_acolyte_legs.vmdl",nil)
        --    GameMode:AttachWearable(unit,"models/items/dazzle/darkclaw_acolyte_arms/darkclaw_acolyte_arms.vmdl",nil)
        --    GameMode:AttachWearable(unit,"models/items/dazzle/darkclaw_acolyte_weapon/darkclaw_acolyte_weapon.vmdl","particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_ambient.vpcf")
        --end
    end
end

function GameMode:RemoveAllWearables(hero)
    local wearables = {} -- объявление локального массива на удаление
    local cur = hero:FirstMoveChild() -- получаем первый указатель над подобъект объекта hero ()

    while cur ~= nil do --пока наш текущий указатель не равен nil(пустота/пустой указатель)
        cur = cur:NextMovePeer() -- выбираем следующий указатель на подобъект нашего обьекта
        if cur ~= nil and cur:GetClassname() ~= "" and cur:GetClassname() == "dota_item_wearable" then -- проверяем, елси текущий указатель не пуст, название класса не пустое, и если этот класс есть класс "dota_item_wearable", то есть надеваемые косметические предметы
            table.insert(wearables, cur) -- добавляем в таблицу на удаление текущий предмет(сверху проверяли класс текущего объекта)
        end
    end
 
    for i = 1, #wearables do -- собственно цикл для удаления всего занесенного в массив на удаление
        UTIL_Remove(wearables[i]) -- удаляем объект
    end
end

function GameMode:AttachWearable(unit, modelPath,part)
    local wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = modelPath, DefaultAnim=animation, targetname=DoUniqueString("prop_dynamic")})

    wearable:FollowEntity(unit, true)
    
    if part ~= nil then
        local mask1_particle = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN_FOLLOW, wearable )
        ParticleManager:SetParticleControlEnt( mask1_particle, 0, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask1_particle, 1, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask1_particle, 2, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
    end
    
    unit.wearables = unit.wearables or {}
    table.insert(unit.wearables, wearable)

    return wearable
end

function GameMode:RemoveWearables(unit)
    if not unit.wearables or #unit.wearables == 0 then
        return
    end

    for _, part in pairs(unit.wearables) do
        part:RemoveSelf()
    end

    unit.wearables = {}
end

--function GameMode:GetPointEnts()
--    return pointents
--end

function GameMode:StartEndRounds()
    local point = Entities:FindByName( nil, "spawner"):GetAbsOrigin()
    
    CustomGameEventManager:Send_ServerToAllClients( "Close_DamageTop", {})
    
    _G.GAME_ROUND = _G.GAME_ROUND + 1
            
    local heroes = GetAllRealHeroes()
    for i=1, #heroes do
        local modifs = heroes[i]:FindAllModifiers()
        for b=1, #modifs do
            if modifs[b]:GetAbility() ~= nil then
                if modifs[b].needupwawe then
                    modifs[b]:OnWaweChange(_G.GAME_ROUND)
                end
            end
        end
    end
    CustomNetTables:SetTableValue("Hero_Stats","wave",{_G.GAME_ROUND})
    
    print("Wave №" .. _G.GAME_ROUND)
    local waveinfo = {
        message = "Wave №" .. _G.GAME_ROUND,
        duration  = 3
    }
    FireGameEvent("show_center_message",waveinfo)
    EmitGlobalSound("Tutorial.Quest.complete_01")
    for i=1, 5 do
        local num = i + (5*(_G.GAME_ROUND-1))
        if UNITS_NAMES[num] ~= nil then
            for i=1, ROUND_UNITS[num] do
                local unit = CreateUnitByName( UNITS_NAMES[num], point + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
            end
        end
    end
end

CustomGameEventManager:RegisterListener("set_disable_help", function(_, data)
	local to = data.to;
	if PlayerResource:IsValidPlayerID(to) then
		local playerId = data.PlayerID;
		local disable = data.disable == 1
		PlayerResource:SetUnitShareMaskForPlayer(playerId, to, 4, disable)

		local disableHelp = CustomNetTables:GetTableValue("disable_help", tostring(playerId)) or {}
		disableHelp[tostring(to)] = disable
		CustomNetTables:SetTableValue("disable_help", tostring(playerId), disableHelp)
	end
end)