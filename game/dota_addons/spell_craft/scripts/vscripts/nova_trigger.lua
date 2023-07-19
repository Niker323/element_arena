function Triggered(event)
	caster = event.caster
	novaAbility = caster:FindAbilityByName( "phoenix_supernova_datadriven" )
	Refresher = caster:FindItemInInventory( "item_refresher" )
	if _G.hardmode then
		if Refresher:IsFullyCastable() then
			if caster:GetHealth() < 500 and novaAbility:IsFullyCastable() then
				caster:SetHealth(50000)
				novaAbility:StartCooldown(9999)
				caster:RemoveModifierByName("nova_trigger")
				caster:RemoveModifierByName("modifier_fire_spirit_stack_datadriven")
				novaAbility:ApplyDataDrivenModifier(caster, caster, "nova_trigger", nil)
			end
		else
			if caster:GetHealth() < 500 and novaAbility:IsFullyCastable() then
				caster:SetHealth(50000)
				novaAbility:StartCooldown(9999)
				caster:RemoveModifierByName("nova_trigger")
				caster:RemoveModifierByName("modifier_fire_spirit_stack_datadriven")
			end
		end
	else
		if caster:GetHealth() < 500 and novaAbility:IsFullyCastable() then
			caster:SetHealth(50000)
			novaAbility:StartCooldown(9999)
			caster:RemoveModifierByName("nova_trigger")
			caster:RemoveModifierByName("modifier_fire_spirit_stack_datadriven")
		end
	end
end