--[[Author: YOLOSPAGHETTI
	Date: February 13, 2016
	Checks the target's distance from its last position and deals damage accordingly]]
function DistanceCheck(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if ability ~= nil then
	local movement_damage_pct = ability:GetLevelSpecialValueFor( "movement_damage_pct", ability:GetLevel() - 1 )/100
	if _G.hardmode then
		movement_damage_pct = movement_damage_pct * 2
	end
	local damage_cap_amount = ability:GetLevelSpecialValueFor( "damage_cap_amount", ability:GetLevel() - 1 )
	if _G.hardmode then
		damage_cap_amount = damage_cap_amount * 2
	end
	local position = target:GetAbsOrigin()
	if target.origin ~= null then
		local distance = math.sqrt((target.origin.x - position.x)^2 + (target.origin.y - position.y)^2)
		if distance <= damage_cap_amount and distance > 0 then
			damage = distance * (target:GetMaxHealth()/2500)
		end
	end
	target.origin = position
	if damage ~= nil then
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
        damage = nil
	end
    end
end
