function GetAllRealHeroes()
    local rheroes = {}
    local heroes = HeroList:GetAllHeroes()
    
    for i=1,#heroes do
        if heroes[i]:IsRealHero() then
            table.insert(rheroes,heroes[i])
        end
    end
    return rheroes
end

function RefreshPlayers()
    local heroes = GetAllRealHeroes()
    for i=1, #heroes do
		if not heroes[i]:IsAlive() then
            heroes[i]:SetRespawnPosition(heroes[i]:GetOrigin())
            heroes[i]:RespawnHero( false, false )
		end
		heroes[i]:SetHealth( heroes[i]:GetMaxHealth() )
		heroes[i]:SetMana( heroes[i]:GetMaxMana() )
        for y=0, 9, 1 do
            local current_item = heroes[i]:GetItemInSlot(y)
            if current_item ~= nil then
                if current_item:GetName() == "item_bottle" then
                    current_item:SetCurrentCharges(3)
                end
            end
        end
        local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti8/mekanism_ti8.vpcf", PATTACH_ABSORIGIN_FOLLOW, heroes[i] )
        ParticleManager:ReleaseParticleIndex( pfx )
	end
end

function SetCameraToPosForPlayer(playerID,vector)
    -- print(playerID)
	local netTable = {}
	netTable["PosX"] = vector[1]
	netTable["PosY"] = vector[2]
	netTable["PosZ"] = vector[3]

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "move_camera", netTable )
end

function ChangeWorldBounds(vMin, vMax)
    local oldBounds = Entities:FindByClassname(nil, "world_bounds")
	if oldBounds then 
		oldBounds:RemoveSelf()
	end

    SpawnEntityFromTableSynchronous("world_bounds", {Min = vMin, Max = vMax})
    
    -- FireGameEvent("change_world_bounds", {Min = vMin, Max = vMax})
end

function DisplayError(playerId, message)
	local player = PlayerResource:GetPlayer(playerId)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = message })
	end
end

function TeleportPlayerToZone(playerId, zonename)
    local hero = PlayerResource:GetSelectedHeroEntity(playerId)
    if hero and hero:IsAlive() then
        hero.zone = zonename
        hero:Stop()
        hero:RemoveModifierByName("modifier_item_mystery_cyclone_active")
        local pfx1 = ParticleManager:CreateParticle( "particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", PATTACH_ABSORIGIN, hero )
        ParticleManager:ReleaseParticleIndex( pfx1 )
        local point = Entities:FindByName( nil, zonename.."_tp_point_1"):GetAbsOrigin()
        FindClearSpaceForUnit(hero, point, true )
        local pfx2 = ParticleManager:CreateParticle( "particles/econ/events/ti4/blink_dagger_end_ti4.vpcf", PATTACH_ABSORIGIN, hero )
        ParticleManager:ReleaseParticleIndex( pfx2 )
        SetCameraToPosForPlayer(playerId,point)
    end
end

function TeleportAllPlayersToZone(zonename)
    local plc = PlayerResource:GetPlayerCount()
    for i=0,plc-1 do
        local hero = PlayerResource:GetSelectedHeroEntity(i)
        if hero then
            hero.zone = zonename
            hero:Stop()
            hero:RemoveModifierByName("modifier_item_mystery_cyclone_active")
            local pfx1 = ParticleManager:CreateParticle( "particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", PATTACH_ABSORIGIN, hero )
            ParticleManager:ReleaseParticleIndex( pfx1 )
            local point = Entities:FindByName( nil, zonename.."_tp_point_"..(i+1)):GetAbsOrigin()
            FindClearSpaceForUnit(hero, point, true )
            local pfx2 = ParticleManager:CreateParticle( "particles/econ/events/ti4/blink_dagger_end_ti4.vpcf", PATTACH_ABSORIGIN, hero )
            ParticleManager:ReleaseParticleIndex( pfx2 )
            SetCameraToPosForPlayer(i,point)
        end
    end
end

function IsFreeSpaceInInventory(hero)
    for i=0,14 do
        if hero:GetItemInSlot(i) == nil then
            return true
        end
    end
    return false
end