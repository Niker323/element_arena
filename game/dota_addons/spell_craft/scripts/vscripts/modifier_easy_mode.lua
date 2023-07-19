modifier_easy_mode = class({})

function modifier_easy_mode:IsHidden() return true end
function modifier_easy_mode:IsPurgable() return false end
function modifier_easy_mode:IsPurgeException() return false end
function modifier_easy_mode:RemoveOnDeath() return false end

function modifier_easy_mode:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_easy_mode:GetModifierIncomingDamage_Percentage()
	return -15
end