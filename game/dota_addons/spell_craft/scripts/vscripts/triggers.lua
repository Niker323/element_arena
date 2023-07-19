function OnEndTouchTrigger(trigger)
    -- print("OnEndTouchTrigger")
    local activator = trigger.activator
    local callerName = trigger.caller:GetName()
    local zoneName = string.sub(callerName, 0, string.len(callerName)-8)
    -- print(zoneName)
    if activator.zone and activator.zone == zoneName then
        local origin = activator:GetAbsOrigin()
        local triggerorigin = trigger.caller:GetAbsOrigin()
        local mins = trigger.caller:GetBoundingMins() + triggerorigin
        local maxs = trigger.caller:GetBoundingMaxs() + triggerorigin
        if origin.x < mins.x or origin.y < mins.y or origin.x > maxs.x or origin.y > maxs.y then
            TeleportPlayerToZone(activator:GetPlayerID(), zoneName)
        end
    end
end