
function OnToggleOn( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster._attacking = false
	caster._active_split_shot = true
end

function OnToggleOff( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster._attacking = false	
	if caster:IsAlive() then
		caster._active_split_shot = false
	end
end

function OnOwnerSpawned( keys )
	-- print('OnOwnerSpawned')
	print('active: '.. tostring( keys.caster._active_split_shot))
	local caster = keys.caster
	local ability = keys.ability
	if caster._active_split_shot then
		ability:ToggleAbility()
	end
end

function OnOwnerDied( keys )
	-- print('OnOwnerDied')
	local caster = keys.caster
	local ability = keys.ability
	-- caster._active_split_shot = ability:GetToggleState()
end

--[[
	Creates additional attack projectiles for units within the specified radius around the caster]]
function SplitShotLaunch( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Targeting variables
	local target_type = ability:GetAbilityTargetType()
	local target_team = ability:GetAbilityTargetTeam()
	local target_flags = ability:GetAbilityTargetFlags()
	local attack_target = caster:GetAttackTarget()

	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("range", ability_level)
	radius_plus = radius + caster:GetAttackRangeBuffer()
	-- local max_targets = ability:GetLevelSpecialValueFor("arrow_count", ability_level)
	local max_targets = GetTalentSpecialValueFor(ability, "arrow_count")
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local split_shot_projectile = keys.split_shot_projectile

	-- local split_shot_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)
	local split_shot_targets = FindTargetEnemy(caster, caster_location, radius_plus)

	-- Create projectiles for units that are not the casters current attack target
	for _,v in pairs(split_shot_targets) do
		if v ~= attack_target then
			local projectile_info = 
			{
				EffectName = split_shot_projectile,
				Ability = ability,
				vSpawnOrigin = caster_location,
				Target = v,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = false
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
		-- If we reached the maximum amount of targets then break the loop
		if max_targets == 0 then break end
	end
end

-- Apply the auto attack damage to the hit unit
function SplitShotDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local damage_amount = caster:GetAttackDamage()

	local dmg_table_target = {
		victim = target,
		attacker = caster,
		damage = damage_amount,
        damage_type = ability:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
	    ability = ability,
	}
	ApplyDamage(dmg_table_target)
end

---------------------------------------------------------------------------------------------------------------

function HasTalent(unit, talentName)
    if unit:HasAbility(talentName) then
        if unit:FindAbilityByName(talentName):GetLevel() > 0 then return true end
    end
    return false
end

function GetTalentSpecialValueFor(ability, value)
    local base = ability:GetSpecialValueFor(value)
    local talentName
    local kv = ability:GetAbilityKeyValues()
    for k,v in pairs(kv) do -- trawl through keyvalues
        if k == "AbilitySpecial" then
            for l,m in pairs(v) do
                if m[value] then
                    talentName = m["LinkedSpecialBonus"]
                end
            end
        end
    end
    if talentName then 
        local talent = ability:GetCaster():FindAbilityByName(talentName)
        if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
    end
    return base
end

function FindTargetEnemy(unit, point, radius_plus)
    local iTeamNumber = unit:GetTeamNumber()
    local vPosition = point
    local hCacheUnit = nil
    local flRadius = radius_plus
    local iTeamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iTypeFilter = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC --DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
    local iFlagFilter = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE   
    local iOrder = FIND_CLOSEST
    local bCanGrowCache = false
    return FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, 
        flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
end
