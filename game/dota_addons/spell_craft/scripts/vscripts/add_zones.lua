AddZones = AddZones or {
	zone_map = {
        "add_zone_1",
        "add_zone_1",
        "add_zone_2",
        "add_zone_3",
        -- "add_zone_3",
    },
    free_maps = {
        add_zone_1 = true,
        add_zone_2 = true,
        add_zone_3 = true,
        add_zone_4 = true,
    },
    add_zone_data = {}
}

-- function AddZones:Init()
-- 	-- LinkLuaModifier( "modifier_cosmetic_pet", "modifiers/modifier_cosmetic_pet", LUA_MODIFIER_MOTION_NONE )
-- 	-- LinkLuaModifier( "modifier_cosmetic_pet_invisible", "modifiers/modifier_cosmetic_pet_invisible", LUA_MODIFIER_MOTION_NONE )

-- 	-- RegisterCustomEventListener( "cosmetics_select_pet", Dynamic_Wrap( self, "CreatePet" ) )
-- 	-- RegisterCustomEventListener( "cosmetics_remove_pet", Dynamic_Wrap( self, "DeletePet" ) )
-- end

function AddZones:StartZone(zone_id, hero)
    if AddZones.free_maps[AddZones.zone_map[zone_id]] then
        AddZones.free_maps[AddZones.zone_map[zone_id]] = false
        TeleportPlayerToZone(hero:GetPlayerID(), AddZones.zone_map[zone_id])

        AddZones.add_zone_data[zone_id] = {}
        AddZones.add_zone_data[zone_id].hero = hero
        if zone_id == 1 then
            AddZones.add_zone_data[zone_id].units = {}
            local point = Entities:FindByName( nil, AddZones.zone_map[zone_id].."_tp_point_1"):GetAbsOrigin()
            local units_count = 10+math.floor(_G.GAME_ROUND/2)
            if hero:IsRangedAttacker() then
                units_count = units_count + 10
            end
            for i=1, units_count do
                local unit = CreateUnitByName( "npc_dota_add_zone_unit1", point + RandomVector( RandomFloat( 0, 2200 ) - 400 ), true, nil, nil, DOTA_TEAM_BADGUYS )
                unit:AddNewModifier(unit, nil, "modifier_my_black_king_bar", {})
                unit:SetAbsAngles( 0, RandomFloat(-180, 180), 0 )
                local blank_abil = unit:AddAbility("blank_ability")
                blank_abil:SetLevel(1)

                function blank_abil:OnOwnerDied()
                    local units_c = 0
                    for k, loc_unit in pairs(AddZones.add_zone_data[1].units) do
                        if loc_unit == self:GetOwner() then
                            AddZones.add_zone_data[1].units[k] = nil
                        else
                            units_c = units_c + 1
                        end
                    end
                    if units_c == 0 then
                        AddZones:EndZone(1, true)
                    end
                end

                table.insert(AddZones.add_zone_data[zone_id].units, unit)
            end
        elseif zone_id == 2 then
            AddZones.add_zone_data[zone_id].units = {}
            local point = Entities:FindByName( nil, AddZones.zone_map[zone_id].."_tp_point_1"):GetAbsOrigin()
            for i=1, 30 do
                local unit = CreateUnitByName( "npc_dota_add_zone_unit2", point + RandomVector( RandomFloat( 0, 2200 ) - 400 ), true, nil, nil, DOTA_TEAM_BADGUYS )
                unit:AddNewModifier(unit, nil, "modifier_my_black_king_bar", {})
                unit:AddNewModifier(unit, nil, "modifier_invulnerable", {duration = 5})
                unit:SetAbsAngles( 0, RandomFloat(-180, 180), 0 )
                local blank_abil = unit:AddAbility("blank_ability")
                blank_abil:SetLevel(1)

                function blank_abil:OnOwnerDied()
                    if self:GetOwner().targ then
                        AddZones:EndZone(2, true)
                    else
                        TeleportPlayerToZone(AddZones.add_zone_data[2].hero:GetPlayerID(), "main_zone")
                        AddZones:EndZone(2, false)
                    end
                end

                table.insert(AddZones.add_zone_data[zone_id].units, unit)
            end

            local targ = AddZones.add_zone_data[zone_id].units[RandomInt(1, #AddZones.add_zone_data[zone_id].units)]
            targ:SetBaseHealthRegen(1)
            targ.targ = true
        elseif zone_id == 3 then
            local point = Entities:FindByName( nil, AddZones.zone_map[zone_id].."_target_point"):GetAbsOrigin()
            local trigger = CreateUnitByName( "npc_dota_my_custom_trigger", point, false, nil, nil, DOTA_TEAM_GOODGUYS )
            ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, trigger )
            -- trigger.trigger_radius = 100

            function trigger:OnCustomTriggered(kv)
                AddZones:EndZone(3, true)
            end

            AddZones.add_zone_data[zone_id].trigger = trigger
        elseif zone_id == 4 then
            local point = Entities:FindByName( nil, AddZones.zone_map[zone_id].."_tp_point_1"):GetAbsOrigin()
            local trigger = CreateUnitByName( "npc_dota_my_custom_trigger", point + RandomVector( RandomFloat( 0, 1800 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
            ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, trigger )
            trigger.ost = 9
            -- trigger.trigger_radius = 100

            function trigger:OnCustomTriggered(kv)
                if self.ost == 0 then
                    AddZones:EndZone(4, true)
                else
                    local new_point = Entities:FindByName( nil, AddZones.zone_map[4].."_tp_point_1"):GetAbsOrigin()
                    local new_trigger = CreateUnitByName( "npc_dota_my_custom_trigger", point + RandomVector( RandomFloat( 0, 1800 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
                    ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, new_trigger )
                    new_trigger.ost = self.ost - 1
                    new_trigger.OnCustomTriggered = self.OnCustomTriggered
                    AddZones.add_zone_data[4].trigger = new_trigger
                    self:RemoveSelf()
                end
            end

            AddZones.add_zone_data[zone_id].trigger = trigger
        elseif zone_id == 5 then

        end
    end
end

function AddZones:StartRandomZone(hero)
    local zone_ids = {}
    for i=1,#AddZones.zone_map do
        if AddZones.free_maps[AddZones.zone_map[i]] then
            table.insert(zone_ids, i)
        end
    end
    AddZones:StartZone(zone_ids[RandomInt(1, #zone_ids)], hero)
end

function AddZones:EndZone(zone_id, win)
    if win then
        local item_tier = math.floor(_G.GAME_ROUND/10)+1
        local item_name = GetPotentialNeutralItemDrop(item_tier, AddZones.add_zone_data[zone_id].hero:GetTeam())
        local point = Entities:FindByName( nil, AddZones.zone_map[zone_id].."_tp_point_1"):GetAbsOrigin()
        DropNeutralItemAtPositionForHero(item_name, point, AddZones.add_zone_data[zone_id].hero, item_tier, true)
    end
    if zone_id == 1 then
        for _, unit in pairs(AddZones.add_zone_data[zone_id].units) do
            unit:RemoveSelf()
        end
    elseif zone_id == 2 then
        for _, unit in pairs(AddZones.add_zone_data[zone_id].units) do
            unit:RemoveSelf()
        end
    elseif zone_id == 3 then
        AddZones.add_zone_data[zone_id].trigger:RemoveSelf()
    elseif zone_id == 4 then
        AddZones.add_zone_data[zone_id].trigger:RemoveSelf()
    end
    AddZones.add_zone_data[zone_id] = nil
    AddZones.free_maps[AddZones.zone_map[zone_id]] = true
end

function AddZones:EndAllZones()
    for zone_id, _ in pairs(AddZones.add_zone_data) do
        AddZones:EndZone(zone_id, false)
    end
end