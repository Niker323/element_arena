function OnSpellStart(event)
	local caster = event.caster
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    if #enemies < 1 then return end
    local point = enemies[RandomInt(1,#enemies)]:GetAbsOrigin()
    local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( nFXIndex1, 0, point )
	ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( 300, 1, -300 ) )
	ParticleManager:SetParticleControl( nFXIndex1, 2, Vector( 1, 0, 0 ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex1 )
    --local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster )
	--ParticleManager:SetParticleControl( nFXIndex1, 0, point )
	--ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( 300, 0, 0 ) )
	--ParticleManager:SetParticleControl( nFXIndex1, 2, Vector( 14, 0, 14 ) )
	--ParticleManager:SetParticleControl( nFXIndex1, 3, Vector( 200, 0, 0 ) )
	--ParticleManager:SetParticleControl( nFXIndex1, 4, Vector( 0, 0, 0 ) )
    Timers:CreateTimer(1.8,function()
        ParticleManager:DestroyParticle(nFXIndex1, true)
        local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
        local realheroes = {}
        for _, loc_enemy in pairs(enemies2) do
            if loc_enemy:IsRealHero() then
                table.insert(realheroes, loc_enemy)
            end

            local damageTable = {
            victim = loc_enemy,
            attacker = caster,
            damage = 10000,
            damage_type = DAMAGE_TYPE_PHYSICAL
            }
            ApplyDamage(damageTable)
        end
        if #realheroes > 0 then
            local absor = realheroes[1]:GetAbsOrigin()
            local BoundingMaxs = realheroes[1]:GetBoundingMaxs()
            for i=1,#enemies do
                if not enemies[i]:IsNull() then
                    local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, caster)
                    ParticleManager:SetParticleControl(lightningBolt,0,Vector(absor.x,absor.y,absor.z + BoundingMaxs.z ))   
                    ParticleManager:SetParticleControl(lightningBolt,1,Vector(enemies[i]:GetAbsOrigin().x,enemies[i]:GetAbsOrigin().y,enemies[i]:GetAbsOrigin().z + enemies[i]:GetBoundingMaxs().z ))
                    local damageTable = {
                    victim = enemies[i],
                    attacker = caster,
                    damage = 7500,
                    damage_type = DAMAGE_TYPE_MAGICAL
                    }
                    ApplyDamage(damageTable)
                end
            end
        end
        local nFXIndex2 = ParticleManager:CreateParticle( "particles/my_new/my_lina_spell_light_strike_array_ti7.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControl( nFXIndex2, 0, point )
        ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( 300, 1, 1 ) )
        Timers:CreateTimer(1,function()
            ParticleManager:DestroyParticle(nFXIndex2, false)
        end)
    end)
end