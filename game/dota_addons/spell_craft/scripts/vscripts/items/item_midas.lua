item_ea_hand_of_midas = class({})
LinkLuaModifier("modifier_item_ea_hand_of_midas", "items/item_midas", LUA_MODIFIER_MOTION_NONE)
function item_ea_hand_of_midas:GetAbilityTextureName()
	return "item_hand_of_midas"
end
function item_ea_hand_of_midas:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target:GetTeamNumber() == caster:GetTeamNumber() then return 	UF_FAIL_FRIENDLY end
		if target:IsHero() then return 										UF_FAIL_HERO end
		if target:IsOther() then return 									UF_FAIL_CUSTOM end
		if string.find(target:GetUnitName(), "necronomicon") then return 	UF_FAIL_CUSTOM end
		if target:IsConsideredHero() then return 							UF_FAIL_CONSIDERED_HERO end
		if target:IsBuilding() then return 									UF_FAIL_BUILDING end
		return UF_SUCCESS
	end
end
function item_ea_hand_of_midas:GetCustomCastErrorTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target:IsOther() then return "#dota_hud_error_cant_use_on_wards" end
		if string.find(target:GetUnitName(), "necronomicon") then return "#dota_hud_error_cant_use_on_necrobook" end
	end
end
function item_ea_hand_of_midas:GetAbilityTextureName()
	local caster = self:GetCaster()
	local caster_name = caster:GetUnitName()
	local animal_heroes = {
		["npc_dota_hero_brewmaster"] = true,
		["npc_dota_hero_magnataur"] = true,
		["npc_dota_hero_lone_druid"] = true,
		["npc_dota_lone_druid_bear1"] = true,
		["npc_dota_lone_druid_bear2"] = true,
		["npc_dota_lone_druid_bear3"] = true,
		["npc_dota_lone_druid_bear4"] = true,
		["npc_dota_lone_druid_bear5"] = true,
		["npc_dota_lone_druid_bear6"] = true,
		["npc_dota_lone_druid_bear7"] = true,
		["npc_dota_hero_broodmother"] = true,
		["npc_dota_hero_lycan"] = true,
		["npc_dota_hero_ursa"] = true,
		["npc_dota_hero_malfurion"] = true,
	}
	if animal_heroes[caster_name] then return "custom/item_paw_of_midas" end
	return "hand_of_midas"
end
function item_ea_hand_of_midas:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ability = self
	local sound_cast = "DOTA_Item.Hand_Of_Midas"
	local bonus_gold = ability:GetSpecialValueFor("bonus_gold")
	self:StartCooldown(self:GetSpecialValueFor("base_cooldown"))
	target:EmitSound(sound_cast)
	SendOverheadEventMessage(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, target, bonus_gold, nil)
	local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	if not caster:IsHero() then caster = caster:GetPlayerOwner():GetAssignedHero() end
	caster:ModifyGold(bonus_gold, true, 0)
end
function item_ea_hand_of_midas:GetIntrinsicModifierName() return "modifier_item_ea_hand_of_midas" end
modifier_item_ea_hand_of_midas = class({})
function modifier_item_ea_hand_of_midas:IsHidden()		return true end
function modifier_item_ea_hand_of_midas:IsPurgable()	return false end
function modifier_item_ea_hand_of_midas:RemoveOnDeath()	return false end
function modifier_item_ea_hand_of_midas:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_ea_hand_of_midas:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_item_ea_hand_of_midas:GetModifierAttackSpeedBonus_Constant()
	local bonus_attack_speed
	local ability = self:GetAbility()
	if ability then bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed") end return bonus_attack_speed
end