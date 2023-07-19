LinkLuaModifier("modifier_ea_soul_catcher_debuff", "heroes/hero_shadow_demon/sd_soul_catcher.lua", LUA_MODIFIER_MOTION_NONE)
ea_sd_soul_catcher = class({})
function ea_sd_soul_catcher:GetAOERadius() return self:GetSpecialValueFor("radius") end
function ea_sd_soul_catcher:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local responses_catch = {"shadow_demon_shadow_demon_ability_soul_catcher_01", "shadow_demon_shadow_demon_ability_soul_catcher_02", "shadow_demon_shadow_demon_ability_soul_catcher_03", "shadow_demon_shadow_demon_ability_soul_catcher_08"}
	local responses_miss = {"shadow_demon_shadow_demon_ability_soul_catcher_04", "shadow_demon_shadow_demon_ability_soul_catcher_05", "shadow_demon_shadow_demon_ability_soul_catcher_06", "shadow_demon_shadow_demon_ability_soul_catcher_07"}
	local cast_sound = "Hero_ShadowDemon.Soul_Catcher.Cast"
	local hit_sound = "Hero_ShadowDemon.Soul_Catcher"
	local modifier_debuff = "modifier_ea_soul_catcher_debuff"
	local particle_ground = "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_v2_projected_ground.vpcf"
	local particle_hit = "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher.vpcf"
	local health_lost = ability:GetSpecialValueFor("health_lost")
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	EmitSoundOn(cast_sound, caster)
	local particle_ground_fx = ParticleManager:CreateParticle(particle_ground, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_ground_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_ground_fx, 1, target_point)
	ParticleManager:SetParticleControl(particle_ground_fx, 2, target_point)
	ParticleManager:SetParticleControl(particle_ground_fx, 3, Vector(radius,0,0))
	Timers:CreateTimer(0.1, function()
		ParticleManager:DestroyParticle(particle_ground_fx, false)
		ParticleManager:ReleaseParticleIndex(particle_ground_fx)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			  target_point,
			  nil,
			  radius,
			  DOTA_UNIT_TARGET_TEAM_ENEMY,
			  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			  DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			  FIND_ANY_ORDER,
			  false)
	local total_health_stolen = 0
	for _, enemy in pairs(enemies) do
		local valid_enemy = true
		if not enemy:IsAlive()  then valid_enemy = false end
		if enemy:IsMagicImmune() then valid_enemy = false end
		if valid_enemy then
			EmitSoundOn(hit_sound, enemy)
			local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(particle_hit_fx, 1, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_hit_fx, 2, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_hit_fx, 3, Vector(1,0,0))
			ParticleManager:SetParticleControl(particle_hit_fx, 4, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_hit_fx)
			local health_steal = enemy:GetHealth() * health_lost * 0.01
			total_health_stolen = total_health_stolen + health_steal
			local damageTable = {victim = enemy,
					attacker = caster,
					damage = health_steal,
					damage_type = DAMAGE_TYPE_PURE,
					damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
					ability = ability}
			ApplyDamage(damageTable)
			enemy:AddNewModifier(enemy, ability, modifier_debuff, {duration = duration, health_stolen = health_steal})
		end
	end
	if RollPercentage(75) then
		if #enemies > 0 then
			EmitSoundOn(responses_catch[RandomInt(1, #responses_catch)], caster)
		else
			EmitSoundOn(responses_miss[RandomInt(1, #responses_miss)], caster)
		end
	end
	if #enemies <= 0 then return end
end
modifier_ea_soul_catcher_debuff = modifier_ea_soul_catcher_debuff or class({})
function modifier_ea_soul_catcher_debuff:IsHidden() return false end
function modifier_ea_soul_catcher_debuff:IsPurgable() return true end
function modifier_ea_soul_catcher_debuff:IsDebuff() return true end
function modifier_ea_soul_catcher_debuff:OnCreated(params)
	if IsServer() then if not self:GetAbility() then self:Destroy() end end
	self.caster = self:GetAbility():GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_debuff = "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_debuff.vpcf"
	self.health_returned_pct = self.ability:GetSpecialValueFor("health_returned_pct")
	if not IsServer() then return end
	self.particle_debuff_fx = ParticleManager:CreateParticle(self.particle_debuff, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle_debuff_fx, 0, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_debuff_fx, false, false, -1, false, false)
	self.health_stolen = params.health_stolen   
	self.soul_taken = false
end
function modifier_ea_soul_catcher_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ea_soul_catcher_debuff:DeclareFunctions() local funcs = {MODIFIER_PROPERTY_TOOLTIP} return funcs end
function modifier_ea_soul_catcher_debuff:OnTooltip() return self.health_returned_pct end
function modifier_ea_soul_catcher_debuff:OnDestroy()
	if not IsServer() then return end
	if not self.health_stolen then return end
	if not self.soul_taken then
		local health_restore = self.health_stolen * self.health_returned_pct * 0.01
		self.parent:Heal(health_restore, self.caster)
	end
end