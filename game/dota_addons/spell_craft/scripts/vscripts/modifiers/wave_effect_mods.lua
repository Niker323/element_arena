--modifier_slow_wave_effect
    LinkLuaModifier( "modifier_slow_wave_effect_debuff", "modifiers/wave_effect_mods", LUA_MODIFIER_MOTION_NONE )
    
    modifier_slow_wave_effect = class({})

    function modifier_slow_wave_effect:IsHidden()
        return true
    end

    function modifier_slow_wave_effect:IsAura()
        return true
    end

    function modifier_slow_wave_effect:GetAuraRadius()
        return 5000
    end

    function modifier_slow_wave_effect:GetEffectName()
        return "particles/wave_effects/slow_effect.vpcf"
    end

    function modifier_slow_wave_effect:GetAuraSearchFlags()
        return DOTA_UNIT_TARGET_FLAG_NONE
    end

    function modifier_slow_wave_effect:GetAuraSearchTeam()
        return DOTA_UNIT_TARGET_TEAM_FRIENDLY
    end

    function modifier_slow_wave_effect:GetAuraSearchType()
        return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    end

    function modifier_slow_wave_effect:GetModifierAura()
        return "modifier_slow_wave_effect_debuff"
    end

    --modifier_slow_wave_effect_debuff

    modifier_slow_wave_effect_debuff = class({})

    function modifier_slow_wave_effect_debuff:IsHidden()
        return false
    end

    function modifier_slow_wave_effect_debuff:IsDebuff()
        return true
    end

    function modifier_slow_wave_effect_debuff:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        }

        return funcs
    end

    function modifier_slow_wave_effect_debuff:GetModifierMoveSpeedBonus_Percentage( params )
        return -15
    end

--modifier_min_armor_wave_effect
    LinkLuaModifier( "modifier_min_armor_wave_effect_debuff", "modifiers/wave_effect_mods", LUA_MODIFIER_MOTION_NONE )
    
    modifier_min_armor_wave_effect = class({})

    function modifier_min_armor_wave_effect:IsHidden()
        return true
    end

    function modifier_min_armor_wave_effect:IsAura()
        return true
    end

    function modifier_min_armor_wave_effect:GetAuraRadius()
        return 5000
    end

    function modifier_min_armor_wave_effect:GetEffectName()
        return "particles/wave_effects/min_armor_effect.vpcf"
    end

    function modifier_min_armor_wave_effect:GetAuraSearchFlags()
        return DOTA_UNIT_TARGET_FLAG_NONE
    end

    function modifier_min_armor_wave_effect:GetAuraSearchTeam()
        return DOTA_UNIT_TARGET_TEAM_FRIENDLY
    end

    function modifier_min_armor_wave_effect:GetAuraSearchType()
        return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    end

    function modifier_min_armor_wave_effect:GetModifierAura()
        return "modifier_min_armor_wave_effect_debuff"
    end

    --modifier_min_armor_wave_effect_debuff

    modifier_min_armor_wave_effect_debuff = class({})

    function modifier_min_armor_wave_effect_debuff:IsHidden()
        return false
    end

    function modifier_min_armor_wave_effect_debuff:IsDebuff()
        return true
    end

    function modifier_min_armor_wave_effect_debuff:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        }

        return funcs
    end

    function modifier_min_armor_wave_effect_debuff:GetModifierPhysicalArmorBonus( params )
        return -10
    end

--modifier_miss_wave_effect
    LinkLuaModifier( "modifier_miss_wave_effect_debuff", "modifiers/wave_effect_mods", LUA_MODIFIER_MOTION_NONE )
        
    modifier_miss_wave_effect = class({})

    function modifier_miss_wave_effect:IsHidden()
        return true
    end

    function modifier_miss_wave_effect:IsAura()
        return true
    end

    function modifier_miss_wave_effect:GetAuraRadius()
        return 5000
    end

    function modifier_miss_wave_effect:GetEffectName()
        return "particles/wave_effects/miss_effect.vpcf"
    end

    function modifier_miss_wave_effect:GetAuraSearchFlags()
        return DOTA_UNIT_TARGET_FLAG_NONE
    end

    function modifier_miss_wave_effect:GetAuraSearchTeam()
        return DOTA_UNIT_TARGET_TEAM_FRIENDLY
    end

    function modifier_miss_wave_effect:GetAuraSearchType()
        return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    end

    function modifier_miss_wave_effect:GetModifierAura()
        return "modifier_miss_wave_effect_debuff"
    end

    --modifier_miss_wave_effect_debuff

    modifier_miss_wave_effect_debuff = class({})

    function modifier_miss_wave_effect_debuff:IsHidden()
        return false
    end

    function modifier_miss_wave_effect_debuff:IsDebuff()
        return true
    end

    function modifier_miss_wave_effect_debuff:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_MISS_PERCENTAGE,
        }

        return funcs
    end

    function modifier_miss_wave_effect_debuff:GetModifierMiss_Percentage( params )
        return 15
    end

--modifier_regen_wave_effect
    LinkLuaModifier( "modifier_regen_wave_effect_buff", "modifiers/wave_effect_mods", LUA_MODIFIER_MOTION_NONE )
            
    modifier_regen_wave_effect = class({})

    function modifier_regen_wave_effect:IsHidden()
        return true
    end

    function modifier_regen_wave_effect:IsAura()
        return true
    end

    function modifier_regen_wave_effect:GetAuraRadius()
        return 5000
    end

    function modifier_regen_wave_effect:GetEffectName()
        return "particles/wave_effects/regen_effect.vpcf"
    end

    function modifier_regen_wave_effect:GetAuraSearchFlags()
        return DOTA_UNIT_TARGET_FLAG_NONE
    end

    function modifier_regen_wave_effect:GetAuraSearchTeam()
        return DOTA_UNIT_TARGET_TEAM_FRIENDLY
    end

    function modifier_regen_wave_effect:GetAuraSearchType()
        return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    end

    function modifier_regen_wave_effect:GetModifierAura()
        return "modifier_regen_wave_effect_buff"
    end

    --modifier_regen_wave_effect_buff

    modifier_regen_wave_effect_buff = class({})

    function modifier_regen_wave_effect_buff:IsHidden()
        return false
    end

    function modifier_regen_wave_effect_buff:IsBuff()
        return true
    end

    function modifier_regen_wave_effect_buff:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        }

        return funcs
    end

    function modifier_regen_wave_effect_buff:GetModifierConstantHealthRegen( params )
        return 10
    end

--modifier_speed_wave_effect
    LinkLuaModifier( "modifier_speed_wave_effect_buff", "modifiers/wave_effect_mods", LUA_MODIFIER_MOTION_NONE )
                
    modifier_speed_wave_effect = class({})

    function modifier_speed_wave_effect:IsHidden()
        return true
    end

    function modifier_speed_wave_effect:IsAura()
        return true
    end

    function modifier_speed_wave_effect:GetAuraRadius()
        return 5000
    end

    function modifier_speed_wave_effect:GetEffectName()
        return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_windrun_combo.vpcf"
    end

    function modifier_speed_wave_effect:GetAuraSearchFlags()
        return DOTA_UNIT_TARGET_FLAG_NONE
    end

    function modifier_speed_wave_effect:GetAuraSearchTeam()
        return DOTA_UNIT_TARGET_TEAM_FRIENDLY
    end

    function modifier_speed_wave_effect:GetAuraSearchType()
        return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    end

    function modifier_speed_wave_effect:GetModifierAura()
        return "modifier_speed_wave_effect_buff"
    end

    --modifier_speed_wave_effect_buff

    modifier_speed_wave_effect_buff = class({})

    function modifier_speed_wave_effect_buff:IsHidden()
        return false
    end

    function modifier_speed_wave_effect_buff:IsBuff()
        return true
    end

    function modifier_speed_wave_effect_buff:GetEffectName()
        return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
    end

    function modifier_speed_wave_effect_buff:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        }

        return funcs
    end

    function modifier_speed_wave_effect_buff:GetModifierMoveSpeedBonus_Percentage( params )
        return 15
    end

--modifier_armor_wave_effect
    LinkLuaModifier( "modifier_armor_wave_effect_buff", "modifiers/wave_effect_mods", LUA_MODIFIER_MOTION_NONE )
                
    modifier_armor_wave_effect = class({})

    function modifier_armor_wave_effect:IsHidden()
        return true
    end

    function modifier_armor_wave_effect:IsAura()
        return true
    end

    function modifier_armor_wave_effect:GetAuraRadius()
        return 5000
    end

    function modifier_armor_wave_effect:GetEffectName()
        return "particles/wave_effects/armor_effect.vpcf"
    end

    function modifier_armor_wave_effect:GetAuraSearchFlags()
        return DOTA_UNIT_TARGET_FLAG_NONE
    end

    function modifier_armor_wave_effect:GetAuraSearchTeam()
        return DOTA_UNIT_TARGET_TEAM_FRIENDLY
    end

    function modifier_armor_wave_effect:GetAuraSearchType()
        return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    end

    function modifier_armor_wave_effect:GetModifierAura()
        return "modifier_armor_wave_effect_buff"
    end

    --modifier_armor_wave_effect_buff

    modifier_armor_wave_effect_buff = class({})

    function modifier_armor_wave_effect_buff:IsHidden()
        return false
    end

    function modifier_armor_wave_effect_buff:IsBuff()
        return true
    end

    function modifier_armor_wave_effect_buff:DeclareFunctions()
        local funcs = 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        }

        return funcs
    end

    function modifier_armor_wave_effect_buff:GetModifierPhysicalArmorBonus( params )
        return 10
    end
    