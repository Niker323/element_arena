modifier_my_black_king_bar = class({})

function modifier_my_black_king_bar:CheckState()
	local state = {}
	state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	return state
end

function modifier_my_black_king_bar:IsPurgable() return false end
function modifier_my_black_king_bar:IsHidden() return true end