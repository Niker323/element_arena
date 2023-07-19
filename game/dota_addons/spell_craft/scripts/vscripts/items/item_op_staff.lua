item_op_staff = class({})
LinkLuaModifier( "mod_seal_1", "modifiers/mod_seal_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "mod_op_staff", "items/item_op_staff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spirit", "items/item_op_staff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spirit_attack_speed", "items/item_op_staff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "mind_mod", "items/item_op_staff", LUA_MODIFIER_MOTION_NONE )

function item_op_staff:OnSpellStart()
	if IsServer() then
		local caster	= self:GetCaster()
        local ability	= self
        
        local nFXIndex = ParticleManager:CreateParticle( "particles/ea_items/op_staff/op_staff_act_dragon.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        
         if caster.spirit1 ~= nil then
            if not caster.spirit1:IsNull() then
                caster.spirit1:AddNewModifier(caster, ability, "modifier_spirit_attack_speed", {duration = 5})
                Timers:CreateTimer(0.1, function()
                    ability.speed = 4
                end)
                Timers:CreateTimer(0.2, function()
                    ability.speed = 6
                end)
                Timers:CreateTimer(0.3, function()
                    ability.speed = 8
                end)
                Timers:CreateTimer(0.4, function()
                    ability.speed = 10
                end)
                Timers:CreateTimer(5, function()
                    ability.speed = 8
                end)
                Timers:CreateTimer(5.1, function()
                    ability.speed = 6
                end)
                Timers:CreateTimer(5.2, function()
                    ability.speed = 4
                end)
                Timers:CreateTimer(5.3, function()
                    ability.speed = 2
                end)
            end
        end
        if caster.spirit2 ~= nil then
            if not caster.spirit2:IsNull() then
                caster.spirit2:AddNewModifier(caster, ability, "modifier_spirit_attack_speed", {duration = 5})
            end
        end
        if caster.spirit3 ~= nil then
            if not caster.spirit3:IsNull() then
                caster.spirit3:AddNewModifier(caster, ability, "modifier_spirit_attack_speed", {duration = 5})
            end
        end
	end
end
--------------------------------------------------------------------------------

function item_op_staff:GetIntrinsicModifierName()
	return "mod_op_staff"
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

mod_op_staff = class({})
--------------------------------------------------------------------------------

function mod_op_staff:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function mod_op_staff:IsPurgable()
	return false
end

function mod_op_staff:RemoveOnDeath()
    return false
end

function mod_op_staff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function mod_op_staff:GetModifierHealthBonus()
	return self.hp
end

function mod_op_staff:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function mod_op_staff:GetModifierBonusStats_Agility()
	return self.agil
end

function mod_op_staff:GetModifierBonusStats_Strength()
	return self.str
end

function mod_op_staff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function mod_op_staff:GetModifierMoveSpeedBonus_Constant()
	return self.speed
end

function mod_op_staff:GetModifierStatusResistanceStacking()
	return self.stat_res
end

function mod_op_staff:GetModifierConstantManaRegen()
	return self.mana_regen
end

function mod_op_staff:GetModifierAttackRangeBonus()
	return self.range
end

----------------------------------------

function mod_op_staff:OnAttackLanded(kv)
    if IsServer() then
        local caster	= self:GetCaster()
        local attacker	= kv.attacker
        if attacker == caster then
            if RandomInt(1,100) <= 40 then
                local ability	= self:GetAbility()
                local target	= kv.target
                target:AddNewModifier(caster, ability, "mind_mod", {duration = self.maim_duration})
                local damageInfo =
				{
					victim = target,
					attacker = caster,
					damage = self.bonus_chance_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability,
				}
				ApplyDamage( damageInfo )
            end
        end
    end
end

----------------------------------------

function mod_op_staff:OnCreated( kv )
    local ability	= self:GetAbility()

    self.hp = ability:GetSpecialValueFor( "hp" )
	self.damage = ability:GetSpecialValueFor( "damage" )
	self.agil = ability:GetSpecialValueFor( "agil" )
	self.str = ability:GetSpecialValueFor( "str" )
	self.attack_speed = ability:GetSpecialValueFor( "attack_speed" )
	self.speed = ability:GetSpecialValueFor( "speed" )
	self.stat_res = ability:GetSpecialValueFor( "stat_res" )
    self.mana_regen = ability:GetSpecialValueFor( "mana_regen" )
    self.range = ability:GetSpecialValueFor( "range" )

	if IsServer() then
        local caster	= self:GetCaster()
        Timers:CreateTimer(0.1, function()
            caster:AddNewModifier(caster, ability, "mod_seal_1", {})
        end)

        self.maim_duration = ability:GetSpecialValueFor( "maim_duration" )
        self.bonus_chance_damage = ability:GetSpecialValueFor( "bonus_chance_damage" )
        
        ability.rot = 0
        ability.speed = 2
        ability.spirits_startTime		= GameRules:GetGameTime()
        if (caster:IsRangedAttacker() and caster:IsAlive()) then
        --if caster:IsRealHero() then
            if caster.spirit1 ~= nil then
                if not caster.spirit1:IsNull() then
                    caster.spirit1:ForceKill( true )
                    caster.spirit1 = nil
                end
            end
            if caster.spirit2 ~= nil then
                if not caster.spirit2:IsNull() then
                    caster.spirit2:ForceKill( true )
                    caster.spirit2 = nil
                end
            end
            if caster.spirit3 ~= nil then
                if not caster.spirit3:IsNull() then
                    caster.spirit3:ForceKill( true )
                    caster.spirit3 = nil
                end
            end
            
            local casterOrigin	= caster:GetAbsOrigin()
        
        -- Spawn a new spirit1
            local newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, nil, caster:GetTeam() )
            -- Create particle FX
            newSpirit:SetRangedProjectileName("particles/my_new/my_wisp_base_attack.vpcf")
            pfx1 = ParticleManager:CreateParticle( "particles/my2_wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )
            newSpirit.pfx = pfx1
            caster.spirit1 = newSpirit
            -- Apply the spirit modifier
            newSpirit:AddNewModifier(caster, ability, "modifier_spirit", {})
            
        -- Spawn a new spirit2
            newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, nil, caster:GetTeam() )
            -- Create particle FX
            newSpirit:SetRangedProjectileName("particles/my_new/my_wisp_base_attack.vpcf")
            pfx2 = ParticleManager:CreateParticle( "particles/my2_wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )
            newSpirit.pfx = pfx2
            caster.spirit2 = newSpirit
            -- Apply the spirit modifier
            newSpirit:AddNewModifier(caster, ability, "modifier_spirit", {})
            
        -- Spawn a new spirit3
            newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, nil, caster:GetTeam() )
            -- Create particle FX
            newSpirit:SetRangedProjectileName("particles/my_new/my_wisp_base_attack.vpcf")
            pfx3 = ParticleManager:CreateParticle( "particles/my2_wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )
            newSpirit.pfx = pfx3
            caster.spirit3 = newSpirit
            -- Apply the spirit modifier
            newSpirit:AddNewModifier(caster, ability, "modifier_spirit", {})
        --end
            self:StartIntervalThink( 0.03 )
        else
            local spiritModifier	= "modifier_spirit"
            
            if caster.spirit1 ~= nil then
                if not caster.spirit1:IsNull() then
                    caster.spirit1:RemoveModifierByName( spiritModifier )
                end
            end
            
            if caster.spirit2 ~= nil then
                if not caster.spirit2:IsNull() then
                    caster.spirit2:RemoveModifierByName( spiritModifier )
                end
            end
            
            if caster.spirit3 ~= nil then
                if not caster.spirit3:IsNull() then
                    caster.spirit3:RemoveModifierByName( spiritModifier )
                end
            end
        end
    end
end

function mod_op_staff:OnIntervalThink()
	if IsServer() then
		local caster	= self:GetCaster()
        local ability	= self:GetAbility()
        local spiritModifier	= "modifier_spirit"
        local casterOrigin	= caster:GetAbsOrigin()
        
        if (caster:IsRangedAttacker() and caster:IsAlive()) then
            --if caster:IsRealHero() then
                local currentRadius = 100
                if caster.spirit1 ~= nil then
                    local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
                    local rotationAngle = ability.rot - 60
                    
                    local relPos = Vector( 0, currentRadius, 0 )
                    relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                    
                    local absPos = GetGroundPosition( relPos + casterOrigin, caster.spirit1 )

                    caster.spirit1:SetAbsOrigin( absPos )
                    caster.spirit1:SetBaseDamageMin(caster:GetAttackDamage())
                    caster.spirit1:SetBaseDamageMax(caster:GetAttackDamage())

                    -- Update particle
                    ParticleManager:SetParticleControl( caster.spirit1.pfx, 1, Vector( currentRadius, 0, 0 ) )
                else
                -- Spawn a new spirit1
                    local newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, nil, caster:GetTeam() )
                    -- Create particle FX
                    newSpirit:SetRangedProjectileName("particles/my_new/my_wisp_base_attack.vpcf")
                    pfx1 = ParticleManager:CreateParticle( "particles/my2_wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )
                    newSpirit.pfx =pfx1
                    caster.spirit1 = newSpirit
                    -- Apply the spirit modifier
                    newSpirit:AddNewModifier(caster, ability, "modifier_spirit", {})
                end
                if caster.spirit2 ~= nil then
                    local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
                    local rotationAngle = ability.rot - 180
                    
                    local relPos = Vector( 0, currentRadius, 0 )
                    relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                    
                    local absPos = GetGroundPosition( relPos + casterOrigin, caster.spirit2 )

                    caster.spirit2:SetAbsOrigin( absPos )
                    caster.spirit2:SetBaseDamageMin(caster:GetAttackDamage())
                    caster.spirit2:SetBaseDamageMax(caster:GetAttackDamage())

                    -- Update particle
                    ParticleManager:SetParticleControl( caster.spirit2.pfx, 1, Vector( currentRadius, 0, 0 ) )
                else
                -- Spawn a new spirit2
                    newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, nil, caster:GetTeam() )
                    -- Create particle FX
                    newSpirit:SetRangedProjectileName("particles/my_new/my_wisp_base_attack.vpcf")
                    pfx2 = ParticleManager:CreateParticle( "particles/my2_wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )
                    newSpirit.pfx =pfx2
                    caster.spirit2 = newSpirit
                    -- Apply the spirit modifier
                    newSpirit:AddNewModifier(caster, ability, "modifier_spirit", {})
                end
                if caster.spirit3 ~= nil then
                    local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
                    local rotationAngle = ability.rot - 300
                    
                    local relPos = Vector( 0, currentRadius, 0 )
                    relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                    
                    local absPos = GetGroundPosition( relPos + casterOrigin, caster.spirit2 )

                    caster.spirit3:SetAbsOrigin( absPos )
                    caster.spirit3:SetBaseDamageMin(caster:GetAttackDamage())
                    caster.spirit3:SetBaseDamageMax(caster:GetAttackDamage())

                    -- Update particle
                    ParticleManager:SetParticleControl( caster.spirit3.pfx, 1, Vector( currentRadius, 0, 0 ) )
                else
                -- Spawn a new spirit3
                    newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, nil, caster:GetTeam() )
                    -- Create particle FX
                    newSpirit:SetRangedProjectileName("particles/my_new/my_wisp_base_attack.vpcf")
                    pfx3 = ParticleManager:CreateParticle( "particles/my2_wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )
                    newSpirit.pfx =pfx3
                    caster.spirit3 = newSpirit
                    -- Apply the spirit modifier
                    newSpirit:AddNewModifier(caster, ability, "modifier_spirit", {})
                end
                ability.rot = ability.rot + ability.speed
            --end
        else
            if caster.spirit1 ~= nil then
                if not caster.spirit1:IsNull() then
                    caster.spirit1:RemoveModifierByName( spiritModifier )
                end
            end
            if caster.spirit2 ~= nil then
                if not caster.spirit2:IsNull() then
                    caster.spirit2:RemoveModifierByName( spiritModifier )
                end
            end
            if caster.spirit3 ~= nil then
                if not caster.spirit3:IsNull() then
                    caster.spirit3:RemoveModifierByName( spiritModifier )
                end
            end
        end
	end
end

function mod_op_staff:OnDestroy()
	if IsServer() then
        local caster	= self:GetCaster()
        caster:RemoveModifierByName("mod_seal_1")
        local ability	= self:GetAbility()
        local spiritModifier	= "modifier_spirit"
        
        if caster.spirit1 ~= nil then
            if not caster.spirit1:IsNull() then
                caster.spirit1:RemoveModifierByName( spiritModifier )
            end
        end
        
        if caster.spirit2 ~= nil then
            if not caster.spirit2:IsNull() then
                caster.spirit2:RemoveModifierByName( spiritModifier )
            end
        end
        
        if caster.spirit3 ~= nil then
            if not caster.spirit3:IsNull() then
                caster.spirit3:RemoveModifierByName( spiritModifier )
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

modifier_spirit = class({})

-- function modifier_spirit:OnCreated( kv )
-- 	if IsServer() then
--         --local spiritt = event.target
--         local ability = self:GetAbility()
--         local caster	= self:GetCaster()
        
--         if caster:IsRangedAttacker() then
--         --if event.caster:IsRealHero() then
--         -- Set the spirit to caster
--         --ability:ApplyDataDrivenModifier( spiritt, spiritt, event.additionalModifier, {} )
--         --end
--         end
--     end
-- end

function modifier_spirit:OnDestroy()
	if IsServer() then
        local ability	= self:GetAbility()
        local caster	= self:GetCaster()

        -- Kill
        if caster.spirit1 ~= nil then
        ParticleManager:DestroyParticle( caster.spirit1.pfx, false )
        if not caster.spirit1:IsNull() then
        caster.spirit1:ForceKill( true )
        caster.spirit1 = nil
        end
        end
        
        if caster.spirit2 ~= nil then
        ParticleManager:DestroyParticle( caster.spirit2.pfx, false )
        if not caster.spirit2:IsNull() then
        caster.spirit2:ForceKill( true )
        caster.spirit2 = nil
        end
        end
        
        if caster.spirit3 ~= nil then
        ParticleManager:DestroyParticle( caster.spirit3.pfx, false )
        if not caster.spirit3:IsNull() then
        caster.spirit3:ForceKill( true )
        caster.spirit3 = nil
        end
        end
    end
end

function modifier_spirit:CheckState()
	local state = {}
	state[MODIFIER_STATE_INVULNERABLE] = true
	state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	state[MODIFIER_STATE_UNSELECTABLE] = true
	return state
end

function modifier_spirit:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end

function modifier_spirit:GetModifierAttackRangeBonus()
    return 500
end

------------------------------------------------------------------------------------------------------------------------

modifier_spirit_attack_speed = class({})

function modifier_spirit_attack_speed:OnCreated( kv )
	if IsServer() then
        self.spirit_attack_speed = self:GetAbility():GetSpecialValueFor( "spirit_attack_speed" )
    end
end

function modifier_spirit_attack_speed:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_spirit_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self.spirit_attack_speed
end

------------------------------------------------------------------------------------------------------------------------

mind_mod = class({})

function mind_mod:IsDebuff() 
	return true
end

function mind_mod:OnCreated( kv )
	if IsServer() then
        self.maim_slow_attack = self:GetAbility():GetSpecialValueFor( "maim_slow_attack" )
        self.maim_slow_movement = self:GetAbility():GetSpecialValueFor( "maim_slow_movement" )
    end
end

function mind_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function mind_mod:GetModifierAttackSpeedBonus_Constant()
	return self.maim_slow_attack
end

function mind_mod:GetModifierMoveSpeedBonus_Percentage()
	return self.maim_slow_movement
end