function OnSpellStart( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	ability:StartCooldown(15)
    if target:GetTeam() == caster:GetTeam() then
		ability:ApplyDataDrivenModifier( caster, target, "modifier_item_vessel_of_the_souls_buff", {} )
		caster:EmitSound("DOTA_Item.SpiritVessel.Target.Ally")
		target:Purge(false, true, false, false, false)
    else
        ability:ApplyDataDrivenModifier( caster, target, "modifier_item_vessel_of_the_souls_debuff", {} )
		caster:EmitSound("DOTA_Item.SpiritVessel.Target.Enemy")
    end
end