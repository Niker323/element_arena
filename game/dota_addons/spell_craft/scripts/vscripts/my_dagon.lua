function item_dagon_datadriven_on_spell_start(keys)
	local dagon_level = keys.ability:GetLevel()
	local ability = keys.ability
	local dagon_particle = ParticleManager:CreateParticle("particles/econ/events/ti7/dagon_ti7.vpcf",  PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(dagon_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), false)
	local particle_effect_intensity = 300 + (100 * dagon_level)  --Control Point 2 in Dagon's particle effect takes a number between 400 and 800, depending on its level.
	ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity))
	
	keys.caster:EmitSound("DOTA_Item.Dagon.Activate")
	keys.target:EmitSound("DOTA_Item.Dagon5.Target")
		
	ApplyDamage({victim = keys.target, attacker = keys.caster, ability = ability, damage = keys.Damage, damage_type = DAMAGE_TYPE_MAGICAL,})
end