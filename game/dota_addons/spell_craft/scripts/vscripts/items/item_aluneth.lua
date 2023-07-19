if item_aluneth == nil then item_aluneth = class({}) end
LinkLuaModifier( "modifier_item_aluneth", "items/item_aluneth.lua", LUA_MODIFIER_MOTION_NONE )

function item_aluneth:OnSpellStart()
	if self:GetCurrentCharges() > 0 then
		self:SetCurrentCharges(self:GetCurrentCharges()-1)
		local caster = self:GetCaster()
		local rotationAngle = caster:GetAngles()
		rotationAngle.y = rotationAngle.y - 180*RandomInt(0,1)
		-- Get a random int within a range
		print(rotationAngle)
		local relPos = Vector( 0, -150, 0 )
		relPos = RotatePosition( Vector(0,0,0), rotationAngle, relPos )
		local absPos = GetGroundPosition( relPos + caster:GetAbsOrigin(), caster )
		ProjectileManager:ProjectileDodge(caster)
		local part = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_event_glitch.vpcf", PATTACH_ABSORIGIN, caster)
		local centr = caster:GetAbsOrigin() - ((caster:GetAbsOrigin()-absPos)/2)
		print(centr)
		ParticleManager:SetParticleControl(part,0,centr)
		caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
		caster:SetAbsOrigin(absPos)
		FindClearSpaceForUnit(caster, absPos, false)
		--Timers:CreateTimer(0.04, function()
		--	ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_event_glitch.vpcf", PATTACH_ABSORIGIN, caster)
		--end)
	end
end

function item_aluneth:GetIntrinsicModifierName()
	return "modifier_item_aluneth"
end

-----------------------------------------------------------------------------------------------------------
--	kaya passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_aluneth == nil then modifier_item_aluneth = class({}) end
function modifier_item_aluneth:IsHidden() return true end
function modifier_item_aluneth:IsDebuff() return false end
function modifier_item_aluneth:IsPurgable() return false end
function modifier_item_aluneth:IsPermanent() return true end

-- Declare modifier events/properties
function modifier_item_aluneth:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_item_aluneth:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_aluneth:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_aluneth:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_aluneth:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_aluneth:GetModifierPercentageManacost()
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

function modifier_item_aluneth:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_item_aluneth:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_aluneth:GetModifierCastRangeBonusStacking()
	return self:GetAbility():GetSpecialValueFor("cast_range")
end

function modifier_item_aluneth:OnAbilityExecuted( params )
	if IsServer() then
        if not self:GetCaster():IsIllusion() then
            if params.unit == self:GetCaster() then
				if not params.ability:IsItem() and not params.ability:IsToggle() then
					if self:GetAbility():GetCurrentCharges() < 5 then
						self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges()+1)
					end
                end
            end
        end
    end
	return 0
end