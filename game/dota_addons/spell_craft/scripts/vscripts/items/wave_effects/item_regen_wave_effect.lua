LinkLuaModifier( "modifier_regen_wave_effect", "modifiers/wave_effect_mods", LUA_MODIFIER_MOTION_NONE )
function OnSpellStart( keys )
    local ability = keys.ability
    local charges = ability:GetCurrentCharges()
    if charges > 0 then
        table.insert(_G.wave_effect_mods, _G.gold_spirit:AddNewModifier(_G.gold_spirit, nil, "modifier_regen_wave_effect", {}))
        ability:SpendCharge()
    end
end