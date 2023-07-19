
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SmashAbility = thisEntity:FindAbilityByName( "my_cent" )

	thisEntity:SetContextThink( "HellbearThink", HellbearThink, 1 )
end

--------------------------------------------------------------------------------

function HellbearThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.5
	end

	if SmashAbility ~= nil and SmashAbility:IsCooldownReady() then
		return Smash()
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Smash()
	-- thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.3 } )
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = SmashAbility:entindex(),
		Queue = false,
	})

	return 1.1 -- was 1.2
end