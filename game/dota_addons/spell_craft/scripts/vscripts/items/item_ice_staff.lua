item_ice_staff = class({})
LinkLuaModifier( "mod_seal_1", "modifiers/mod_seal_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "mod_ice_staff", "items/item_ice_staff", LUA_MODIFIER_MOTION_NONE )

function item_ice_staff:OnSpellStart()
     if IsServer() then
        local caster	= self:GetCaster()
        local target = self:GetCursorTarget()
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_staff_lvlup_globe.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControlEnt(nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin()+Vector(0,0,100), false)
        ParticleManager:SetParticleControl(nFXIndex, 5, Vector(1,1,1))
 	end
end
--------------------------------------------------------------------------------

function item_ice_staff:OnChannelThink(interval)
    if IsServer() then
        local caster	= self:GetCaster()
        local target = self:GetCursorTarget()
        if target then
            local nFXIndex = ParticleManager:CreateParticle("particles/econ/events/ti7/dagon_ti7.vpcf",  PATTACH_POINT_FOLLOW, caster)
            ParticleManager:SetParticleControlEnt(nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
            ParticleManager:SetParticleControl(nFXIndex, 2, Vector(400))
            local damageTable = {
                victim = target,
                attacker = caster,
                damage = self:GetSpecialValueFor( "damage_per_stack" )/3,
                damage_type = DAMAGE_TYPE_MAGICAL,
                --damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
                ability = self --Optional.
            }
            ApplyDamage(damageTable)
        end
    end
end

function item_ice_staff:OnChannelFinish()
    if IsServer() then
        self:SetCurrentCharges(0)
        for i=9,28 do
            ParticleManager:SetParticleControl(self.part, i, Vector(0, 0, 0))
        end
    end
end

function item_ice_staff:GetChannelTime()
	return self:GetCurrentCharges()*0.1
end

function item_ice_staff:GetIntrinsicModifierName()
	return "mod_ice_staff"
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

mod_ice_staff = class({})
--------------------------------------------------------------------------------

function mod_ice_staff:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function mod_ice_staff:IsPurgable()
	return false
end

function mod_ice_staff:RemoveOnDeath()
    return false
end

function mod_ice_staff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return funcs
end

function mod_ice_staff:GetModifierHealthBonus()
	return self.hp
end

function mod_ice_staff:GetModifierManaBonus()
	return self.mana
end

function mod_ice_staff:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function mod_ice_staff:GetModifierBonusStats_Agility()
	return self.agil
end

function mod_ice_staff:GetModifierBonusStats_Strength()
	return self.str
end

function mod_ice_staff:GetModifierBonusStats_Intellect()
	return self.int
end

function mod_ice_staff:GetModifierPercentageManacost()
	return self.mana_cdr
end

function mod_ice_staff:GetModifierPercentageManaRegen()
	return self.mana_regen_p
end

function mod_ice_staff:GetModifierSpellAmplify_Percentage()
	return self.spell_damage
end

function mod_ice_staff:GetModifierCastRangeBonusStacking()
	return self.spell_range
end

----------------------------------------

function mod_ice_staff:OnAbilityExecuted( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            if params.unit == self:GetCaster() then
                if not params.ability:IsItem() and not params.ability:IsToggle() then
                    local ability = self:GetAbility()
                    if ability:GetCurrentCharges() < 20 then
                        local charges = ability:GetCurrentCharges()
						ability:SetCurrentCharges(charges+1)
                        ParticleManager:SetParticleControl(ability.part, charges+9, Vector(1, 0, 0))
					end
                end
            end
        end
    end
	return 0
end

----------------------------------------

function mod_ice_staff:OnCreated( kv )
        local ability	= self:GetAbility()

		self.damage = ability:GetSpecialValueFor( "damage" )
		self.agil = ability:GetSpecialValueFor( "agil" )
		self.str = ability:GetSpecialValueFor( "str" )
		self.int = ability:GetSpecialValueFor( "int" )
        self.mana_regen_p = ability:GetSpecialValueFor( "mana_regen_p" )
        self.spell_damage = ability:GetSpecialValueFor( "spell_damage" )
        self.spell_range = ability:GetSpecialValueFor( "spell_range" )
        self.hp = ability:GetSpecialValueFor( "hp" )
        self.mana = ability:GetSpecialValueFor( "mana" )
        self.mana_cdr = ability:GetSpecialValueFor( "mana_cdr" )

	if IsServer() then
        local caster	= self:GetCaster()
        Timers:CreateTimer(0.1, function()
            caster:AddNewModifier(caster, ability, "mod_seal_1", {})
        end)
        ability.part = ParticleManager:CreateParticle( "particles/legendary_items/ice_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
        ParticleManager:SetParticleControl(ability.part, 1, Vector(20, 0, 0))
    end
end

function mod_ice_staff:OnDestroy()
	if IsServer() then
        local caster	= self:GetCaster()
        caster:RemoveModifierByName("mod_seal_1")
    end
end