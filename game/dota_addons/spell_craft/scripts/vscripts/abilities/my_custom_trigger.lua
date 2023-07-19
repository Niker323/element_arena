LinkLuaModifier( "modifier_my_custom_trigger", "abilities/my_custom_trigger", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_my_custom_trigger_buff", "abilities/my_custom_trigger", LUA_MODIFIER_MOTION_NONE )
my_custom_trigger = class({})

function my_custom_trigger:GetIntrinsicModifierName()
	return "modifier_my_custom_trigger"
end

-----------------------------------------------------------------------------------------

modifier_my_custom_trigger = class({})

function modifier_my_custom_trigger:IsHidden()
    return true
end

function modifier_my_custom_trigger:CheckState()
	local state = {}
	state[MODIFIER_STATE_INVULNERABLE] = true
    state[MODIFIER_STATE_NO_HEALTH_BAR] = true
    state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
    state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
    state[MODIFIER_STATE_UNSELECTABLE] = true
	return state
end

function modifier_my_custom_trigger:IsAura()
    return true
end

function modifier_my_custom_trigger:GetAuraRadius()
	if IsServer() then
        return self:GetAbility():GetOwner().trigger_radius or 100
    end
end

function modifier_my_custom_trigger:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_my_custom_trigger:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_my_custom_trigger:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_my_custom_trigger:GetModifierAura()
    return "modifier_my_custom_trigger_buff"
end

--modifier_my_custom_trigger_buff

modifier_my_custom_trigger_buff = class({})

function modifier_my_custom_trigger_buff:IsHidden()
    return true
end

function modifier_my_custom_trigger_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_my_custom_trigger_buff:OnCreated(kv)
    if IsServer() then
        if self:GetAbility():GetOwner().OnCustomTriggered then
            self:GetAbility():GetOwner():OnCustomTriggered(kv)
        end
    end
end