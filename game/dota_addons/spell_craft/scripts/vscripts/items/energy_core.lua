if item_energy_core == nil then item_energy_core = class({}) end
LinkLuaModifier("modifier_item_energy_core", "items/energy_core.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_energy_core_aura", "items/energy_core.lua", LUA_MODIFIER_MOTION_NONE)
function item_energy_core:GetAbilityTextureName() return "custom/item_energy_core" end
function item_energy_core:GetBehavior() return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_AURA end
function item_energy_core:GetCastRange() return self:GetSpecialValueFor("cdr_aura_radius") - self:GetCaster():GetCastRangeBonus() end
function item_energy_core:GetIntrinsicModifierName() return "modifier_item_energy_core" end
if modifier_item_energy_core == nil then modifier_item_energy_core = class({}) end
function modifier_item_energy_core:IsHidden() return true end
function modifier_item_energy_core:IsPurgable() return false end
function modifier_item_energy_core:RemoveOnDeath() return false end
function modifier_item_energy_core:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_energy_core:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_item_energy_core:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("mana")
	end
end
function modifier_item_energy_core:GetModifierConstantManaRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("mana_regen")
	end
end
function modifier_item_energy_core:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("int")
	end
end
function modifier_item_energy_core:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("hp")
	end
end
function modifier_item_energy_core:GetModifierPercentageCooldown()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("cooldown")
	end
end
function modifier_item_energy_core:GetModifierCastRangeBonusStacking()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_cast_range")
	end
end
function modifier_item_energy_core:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		-- Spell lifesteal handler
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			if keys.unit:IsIllusion() then
				if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
				elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.GetMagicalArmorValue then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetMagicalArmorValue()))
				elseif keys.damage_type == DAMAGE_TYPE_PURE then
					keys.damage = keys.original_damage
				end
			end
			if keys.unit:IsCreep() then
				keys.attacker:Heal(math.max(keys.damage, 0) * self:GetAbility():GetSpecialValueFor("spell_lifesteal") * 0.01, keys.attacker)
			else
				keys.attacker:Heal(math.max(keys.damage, 0) * self:GetAbility():GetSpecialValueFor("spell_lifesteal") * 0.01, keys.attacker)
			end
		end
	end
end
function modifier_item_energy_core:IsAura() return true end
function modifier_item_energy_core:IsAuraActiveOnDeath() return false end
function modifier_item_energy_core:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("cdr_aura_radius")
	end
end
function modifier_item_energy_core:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_energy_core:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_energy_core:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_energy_core:GetModifierAura() return "modifier_item_energy_core_aura" end
if modifier_item_energy_core_aura == nil then modifier_item_energy_core_aura = class({}) end
function modifier_item_energy_core_aura:IsDebuff() return false end
function modifier_item_energy_core_aura:IsPurgable() return false end
function modifier_item_energy_core_aura:GetTexture() return "custom/item_energy_core" end
function modifier_item_energy_core_aura:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	self.cdr_aura = self:GetAbility():GetSpecialValueFor("cdr_aura")
end
function modifier_item_energy_core_aura:DeclareFunctions() return { MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, } end
function modifier_item_energy_core_aura:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("cdr_aura") end
