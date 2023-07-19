--immortal_mod_01
    immortal_mod_01 = class({})
    function immortal_mod_01:IsHidden() return true end
    function immortal_mod_01:IsDebuff() return false end
    function immortal_mod_01:IsPurgable() return false end
    function immortal_mod_01:RemoveOnDeath() return false end

    function immortal_mod_01:OnCreated()
        if IsServer() then
            self:StartIntervalThink(0.03)
            if self:GetCaster().reltime == nil then
                self:GetCaster().reltime = 0
            end
        end
    end

    function immortal_mod_01:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        }

        return funcs
    end

    function immortal_mod_01:OnTakeDamage(event)
        if IsServer() then
            if event.unit == self:GetCaster() then
                if GameRules:GetGameTime() - self:GetCaster().reltime > 12 then
                    self:GetCaster():SetHealth(self:GetCaster().myimmorthealth)
                    self:GetCaster().reltime = GameRules:GetGameTime()
                    local px = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
                    ParticleManager:SetParticleControl(px, 0, Vector(self:GetCaster():GetAbsOrigin().x,self:GetCaster():GetAbsOrigin().y,self:GetCaster():GetAbsOrigin().z+100))
                end
            end
        end
    end

    function immortal_mod_01:OnIntervalThink()
        if IsServer() then
            self:GetCaster().myimmorthealth = self:GetCaster():GetHealth()
        end
    end

--immortal_mod_02
    LinkLuaModifier( "immortal_heal", "modifiers/immortal_mods", LUA_MODIFIER_MOTION_NONE )
    immortal_mod_02 = class({})
    function immortal_mod_02:IsHidden() return true end
    function immortal_mod_02:IsDebuff() return false end
    function immortal_mod_02:IsPurgable() return false end
    function immortal_mod_02:RemoveOnDeath() return false end

    function immortal_mod_02:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        }

        return funcs
    end

    function immortal_mod_02:OnTakeDamage(event)
        if IsServer() then
            if event.unit == self:GetCaster() then
                if event.damage > self:GetCaster():GetMaxHealth()*0.4 then
                    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "immortal_heal", {duration = 3})
                end
            end
        end
    end

    immortal_heal = class({})
    function immortal_heal:IsHidden() return false end
    function immortal_heal:IsDebuff() return false end
    function immortal_heal:IsPurgable() return true end

    function immortal_heal:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        }

        return funcs
    end

    function immortal_heal:GetModifierHealthRegenPercentage(event)
        return 5
    end

    function immortal_heal:GetEffectName()
        return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf"
    end

--immortal_mod_03
    immortal_mod_03 = class({})
    function immortal_mod_03:IsHidden() return true end
    function immortal_mod_03:IsDebuff() return false end
    function immortal_mod_03:IsPurgable() return false end
    function immortal_mod_03:RemoveOnDeath() return false end

    function immortal_mod_03:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_SPELLS_REQUIRE_HP,
        }

        return funcs
    end

    function immortal_mod_03:GetModifierSpellsRequireHP( params )
        return 1.0
    end 

--immortal_mod_04
    immortal_mod_04 = class({})
    function immortal_mod_04:IsHidden() return true end
    function immortal_mod_04:IsDebuff() return false end
    function immortal_mod_04:IsPurgable() return false end
    function immortal_mod_04:RemoveOnDeath() return false end

    function immortal_mod_04:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        }

        return funcs
    end

    function immortal_mod_04:GetModifierAttackRangeBonus( params )
        if self:GetParent():IsRangedAttacker() then
            return 200
        end
        return 0
    end

--immortal_mod_05
    LinkLuaModifier( "immortal_grave", "modifiers/immortal_mods", LUA_MODIFIER_MOTION_NONE )
    immortal_mod_05 = class({})
    function immortal_mod_05:IsHidden() return true end
    function immortal_mod_05:IsDebuff() return false end
    function immortal_mod_05:IsPurgable() return false end
    function immortal_mod_05:RemoveOnDeath() return false end

    function immortal_mod_05:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        }

        return funcs
    end

    function immortal_mod_05:OnTakeDamage(event)
        if IsServer() then
            if event.unit == self:GetCaster() then
                if self:GetCaster():GetHealth() <= 0 and RandomInt(1, 5) == 5 then
                    self:GetCaster():SetHealth(1)
                    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "immortal_grave", {duration = 1})
                end
            end
        end
    end

    immortal_grave = class({})
    function immortal_grave:IsHidden() return false end
    function immortal_grave:IsDebuff() return false end
    function immortal_grave:IsPurgable() return true end

    function immortal_grave:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_MIN_HEALTH,
        }

        return funcs
    end

    function immortal_grave:GetMinHealth(event)
        return 1
    end

    function immortal_grave:GetEffectName()
        return "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf"
    end

--immortal_mod_06
    immortal_mod_06 = class({})
    function immortal_mod_06:IsHidden() return true end
    function immortal_mod_06:IsDebuff() return false end
    function immortal_mod_06:IsPurgable() return false end
    function immortal_mod_06:RemoveOnDeath() return false end

    function immortal_mod_06:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        }

        return funcs
    end

    function immortal_mod_06:OnAbilityExecuted( params )
        if IsServer() then
            if params.unit == self:GetParent() then
                if not params.ability:IsItem() and not params.ability:IsToggle() then
                    if RollPercentage(10) then
                        local target = FindUnitsInRadius(params.unit:GetTeam(), params.unit:GetAbsOrigin(), nil, 9999,DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                        for i=1, #target do
                            ParticleManager:CreateParticle("particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, target[i])
                            target[i]:Heal(target[i]:GetMaxHealth()*0.05,params.unit)
                        end
                    end
                end
            end
        end
        return 0
    end
