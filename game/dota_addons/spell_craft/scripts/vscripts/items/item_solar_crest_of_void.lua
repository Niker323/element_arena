function OnSpellStart( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	caster:EmitSound("Blink_Layer.Arcane")
	caster:EmitSound("Blink_Layer.Swift")
    if target:GetTeam() == caster:GetTeam() then
		ability:ApplyDataDrivenModifier( caster, target, "modifier_item_solar_crest_of_void_armor", {} )
    else
        ability:ApplyDataDrivenModifier( caster, target, "modifier_item_solar_crest_of_void_disarmor", {} )
    end
end