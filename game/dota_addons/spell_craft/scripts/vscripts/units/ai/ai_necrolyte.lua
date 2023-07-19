function Spawn( entityKeyValues )
	if not IsServer() then return end
	if thisEntity == nil then return end
	pulse = thisEntity:FindAbilityByName( "death_pulse" )
	shroud = thisEntity:FindAbilityByName( "ghost_shroud" )
	thisEntity:SetContextThink( "necroThink", necroThink, 1 )
end
function necroThink()
	if ( not thisEntity:IsAlive() ) then return -1 end
	if GameRules:IsGamePaused() == true then return 1 end
	if pulse ~= nil and pulse:IsFullyCastable() then
		return cpulse()
	end
	if _G.hardmode and thisEntity:GetHealth() < 17500 and shroud ~= nil and shroud:IsFullyCastable() then
		return ghost()
	end
	return 0.1
end

function cpulse()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = pulse:entindex(),
		Queue = false,
	})
	return 0.1
end
function ghost()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = shroud:entindex(),
		Queue = false,
	})
	return 0.1
end