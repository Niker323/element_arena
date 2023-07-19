function OnSpellStart( keys )
    local ability = keys.ability
    local charges = ability:GetCurrentCharges()
    if charges > 0 then
        for _, mod in pairs(_G.wave_effect_mods) do
            mod:Destroy()
        end
        _G.wave_effect_mods = {}
        ability:SpendCharge()
    end
end