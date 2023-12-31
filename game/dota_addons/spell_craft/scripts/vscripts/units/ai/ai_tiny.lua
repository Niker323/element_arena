function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	tossAbility = thisEntity:FindAbilityByName( "tiny_toss" )
	thisEntity:SetContextThink( "TinyThink", TitanTankThink, 1.7 )
end

function TitanTankThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    
    if tossAbility ~= nil and tossAbility:IsFullyCastable() and #enemies > 0 then
        enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 4000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
        local maxdist = 0
		local unitmaxdist = nil
		for i = 1, #enemies do
			local enemy = enemies[i]
			if enemy ~= nil then
				local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
				if flDist > maxdist then
					maxdist = flDist
					unitmaxdist = enemy
				end
			end
		end
		if unitmaxdist ~= nil then
			return toss(unitmaxdist)
		end
	end
    
	return 1.7
end

function toss( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = tossAbility:entindex(),
        TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 1.7
end