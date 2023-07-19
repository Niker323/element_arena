item_shadow_cuirass = class({})
LinkLuaModifier( "mod_seal_1", "modifiers/mod_seal_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "mod_shadow_cuirass", "items/item_shadow_cuirass", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "heal_mod", "items/item_shadow_cuirass", LUA_MODIFIER_MOTION_NONE )

function item_shadow_cuirass:OnSpellStart()
 	if IsServer() then
        local caster	= self:GetCaster()
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_shadow_strike_body.vpcf", PATTACH_ABSORIGIN, caster )
        local damageTable = {
            victim = caster,
            attacker = caster,
            damage = caster:GetMaxHealth()*0.25,
            damage_type = DAMAGE_TYPE_PURE,
            --damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
            ability = self --Optional.
        }
        ApplyDamage(damageTable)
        caster:AddNewModifier(caster, ability, "heal_mod", {duration = 2})
 	end
end
--------------------------------------------------------------------------------

function item_shadow_cuirass:GetIntrinsicModifierName()
	return "mod_shadow_cuirass"
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

mod_shadow_cuirass = class({})
--------------------------------------------------------------------------------

function mod_shadow_cuirass:IsHidden() 
	return true
end

function mod_shadow_cuirass:GetEffectName()
    return "particles/my_new2/blademail.vpcf"
end

--------------------------------------------------------------------------------

function mod_shadow_cuirass:IsPurgable()
	return false
end

function mod_shadow_cuirass:RemoveOnDeath()
    return false
end

function mod_shadow_cuirass:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function mod_shadow_cuirass:GetModifierPhysicalArmorBonus()
	return self.armor
end

function mod_shadow_cuirass:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function mod_shadow_cuirass:GetModifierBonusStats_Agility()
	return self.agil
end

function mod_shadow_cuirass:GetModifierBonusStats_Strength()
	return self.str
end

function mod_shadow_cuirass:GetModifierBonusStats_Intellect()
	return self.int
end

function mod_shadow_cuirass:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function mod_shadow_cuirass:GetModifierConstantManaRegen()
	return self.mana_regen
end

function mod_shadow_cuirass:GetModifierConstantHealthRegen()
	return self.hp_regen
end

----------------------------------------

function mod_shadow_cuirass:OnAttackLanded(kv)
    if IsServer() then
        local caster	= self:GetCaster()
        local attacker	= kv.attacker
        if attacker == caster then
            if not caster:IsIllusion() then
                caster.att_target = kv.target
            end
        end
    end
end

----------------------------------------

function mod_shadow_cuirass:OnTakeDamage(kv)
    if IsServer() then
        local caster	= self:GetCaster()
        local target	= kv.unit
        if attacker ~= nil and target == caster then
            local attacker	= kv.attacker
            local ability	= self:GetAbility()
            local damage = kv.damage
            local need_damage = damage * (self.otrash / 100)
            if not caster:IsIllusion() and need_damage > 1 then
                if caster:GetAttackCapability() == 1 then
                    if caster.att_target ~= nil then
                        if caster.att_target ~= caster then
                            local nFXIndex = ParticleManager:CreateParticle( "particles/my_wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN, caster.att_target )
                            ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true )
                            local damageTable = {
                                victim = caster.att_target,
                                attacker = caster,
                                damage = need_damage,
                                damage_type = DAMAGE_TYPE_PURE,
                                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
                                ability = ability --Optional.
                            }
                            ApplyDamage(damageTable)
                        end
                    end
                end
                if attacker ~= caster then
                    local nFXIndex = ParticleManager:CreateParticle( "particles/my_new/grimstroke_ink_swell_tick_damage.vpcf", PATTACH_ABSORIGIN, caster )
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetOrigin(), true )
                    ApplyDamage({ 
                        victim = attacker,
                        attacker = caster,
                        damage = need_damage,
                        damage_type = DAMAGE_TYPE_PURE,
                        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
                        ability = ability
                    })
                end
            end
        end
    end
end

----------------------------------------

function mod_shadow_cuirass:OnCreated( kv )
        local ability	= self:GetAbility()

		self.damage = ability:GetSpecialValueFor( "damage" )
		self.armor = ability:GetSpecialValueFor( "armor" )
		self.agil = ability:GetSpecialValueFor( "agil" )
		self.str = ability:GetSpecialValueFor( "str" )
		self.int = ability:GetSpecialValueFor( "int" )
		self.attack_speed = ability:GetSpecialValueFor( "attack_speed" )
        self.mana_regen = ability:GetSpecialValueFor( "mana_regen" )
        self.hp_regen = ability:GetSpecialValueFor( "hp_regen" )

	if IsServer() then
        local caster	= self:GetCaster()
        Timers:CreateTimer(0.1, function()
            caster:AddNewModifier(caster, ability, "mod_seal_1", {})
        end)

        self.otrash = ability:GetSpecialValueFor( "otrash" )
        --self.bonus_chance_damage = ability:GetSpecialValueFor( "bonus_chance_damage" )
        
    end
end

function mod_shadow_cuirass:OnDestroy()
	if IsServer() then
        local caster	= self:GetCaster()
        caster:RemoveModifierByName("mod_seal_1")
    end
end

------------------------------------------------------------------------------------------------------------------------

heal_mod = class({})

function heal_mod:GetTexture()
    return "custom/shadow_cuirass"
end

function heal_mod:OnCreated( kv )
    if IsServer() then
        self:StartIntervalThink( 0.1 )
    end
end

function heal_mod:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        caster:Heal(caster:GetMaxHealth()*0.0125, self)
    end
end