if item_fire_core == nil then item_fire_core = class({}) end
LinkLuaModifier("modifier_item_fire_core", "items/fire_core.lua", LUA_MODIFIER_MOTION_NONE)
function item_fire_core:GetAbilityTextureName() return "custom/item_fire_core" end
function item_fire_core:GetIntrinsicModifierName() return "modifier_item_fire_core" end
if modifier_item_fire_core == nil then modifier_item_fire_core = class({}) end
function modifier_item_fire_core:IsHidden() return true end
function modifier_item_fire_core:IsPurgable() return false end
function modifier_item_fire_core:RemoveOnDeath() return false end
function modifier_item_fire_core:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_fire_core:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_item_fire_core:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("mana")
	end
end
function modifier_item_fire_core:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("int")
	end
end
function modifier_item_fire_core:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("hp")
	end
end
function modifier_item_fire_core:GetModifierPercentageCooldown()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("cooldown")
	end
end
function modifier_item_fire_core:GetModifierCastRangeBonusStacking()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_cast_range")
	end
end
function modifier_item_fire_core:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		-- Spell lifesteal handler
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			if keys.unit:IsIllusion() then
				if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
					keys.damage = keys.original_damage
				elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.GetMagicalArmorValue then
					keys.damage = keys.original_damage
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