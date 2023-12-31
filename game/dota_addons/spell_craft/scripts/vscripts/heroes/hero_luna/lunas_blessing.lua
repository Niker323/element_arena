LinkLuaModifier("modifier_lunas_blessing_buff", "heroes/hero_luna/lunas_blessing.lua", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------------------------

function OnCreated( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local modifier_name = 'modifier_lunas_blessing_buff'
	local pa_buff = "modifier_prim_attribute"

	target:AddNewModifier(caster, ability, modifier_name, {})
end

function OnDestroy( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local modifier_name = 'modifier_lunas_blessing_buff'

	target:RemoveModifierByName(modifier_name)
end

----------------------------------------------------------------------

modifier_lunas_blessing_buff = class ({})
local modifier_class = modifier_lunas_blessing_buff

function modifier_class:IsHidden() return false end
function modifier_class:IsBuff() return true end
function modifier_class:IsPurgable() return false end	

function modifier_class:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end
function modifier_class:GetModifierBonusStats_Strength(kv)
	return self.str_bonus
end
function modifier_class:GetModifierBonusStats_Agility(kv)
	return self.agi_bonus
end
function modifier_class:GetModifierBonusStats_Intellect(kv)
	return self.int_bonus
end

function modifier_class:OnRefresh(kv)
	self:_Init(kv)
end

function modifier_class:OnCreated( kv )
	if IsServer() then
		self:_Init()
		self:StartIntervalThink( 2.0 )
	end
end

function modifier_class:OnIntervalThink()
	local unit = self:GetParent()
	local pa_buff = "modifier_prim_attribute"
	local modifier_name = 'modifier_lunas_blessing_buff'
	if unit and IsValidEntity(unit) and unit:IsRealHero() then
		if self._PrimaryStatValue ~= self:_GetPrimaryStatValue() then
			self:_Init()
			self._PrimaryStatValue = self:_GetPrimaryStatValue()
		end
		if unit:HasModifier(pa_buff) then
			unit:RemoveModifierByName(modifier_name)
		end	
	end
end

function modifier_class:_Init( )
	-- local caster = self:GetCaster()
	local ability = self:GetAbility()
	local unit = self:GetParent()
	if ability then
		self.primary_attribute_per = ability:GetSpecialValueFor("primary_attribute_per")			
	else
		self.primary_attribute_per = 1
	end

	self.str_bonus = 0 
	self.agi_bonus = 0 
	self.int_bonus = 0 
	if unit and IsValidEntity(unit) and unit:IsRealHero() then
		local pa = unit:GetPrimaryAttribute()

		unit:CalculateStatBonus(false)

		local PrimaryStatValue = self:_GetPrimaryStatValue()

		local bonus = PrimaryStatValue * (self.primary_attribute_per / 100)
		if math.abs( bonus ) < 1 then bonus = 1 end

		local STRENGTH = 0
		local AGILITY = 1
		local INTELLIGENCE = 2

		if pa == STRENGTH  then
			self.str_bonus = bonus
		elseif pa == AGILITY  then
			self.agi_bonus = bonus
		elseif pa == INTELLIGENCE  then
			self.int_bonus = bonus
		end
	end
end

function modifier_class:_GetPrimaryStatValue()
	local STRENGTH = 0
	local AGILITY = 1
	local INTELLIGENCE = 2
	local unit = self:GetParent()
	local pa = unit:GetPrimaryAttribute()
	local PrimaryStatValue = 0
	if pa == STRENGTH  then
		PrimaryStatValue = unit:GetStrength()
	elseif pa == AGILITY  then
		PrimaryStatValue = unit:GetAgility()
	elseif pa == INTELLIGENCE  then
		PrimaryStatValue = unit:GetIntellect()
	end
	return PrimaryStatValue
end