-- core.lua Version 4

local frame = CreateFrame("Frame")
local lastAlertTime = 0  -- Initialize a variable to store the time of the last alert

-- Register for the NAME_PLATE_UNIT_ADDED event
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")

frame:SetScript("OnEvent", function(self, event, unit)
    local inInstance, instanceType = IsInInstance()  -- Check if the player is in an instance (Version 2)
    if inInstance then
        return  -- Exit the function early if inside an instance (Version 2)
    end
    
    local currentTime = GetTime()  -- Get the current time
    if currentTime - lastAlertTime >= 60 then  -- Check if at least 60 seconds have passed since the last alert
        -- Make sure the unit is an NPC and is an enemy
        if not UnitIsPlayer(unit) and UnitIsEnemy("player", unit) then
            -- Get the unit's level and classification
            local npcLevel = UnitLevel(unit)
            local npcClassification = UnitClassification(unit)
            local playerLevel = UnitLevel("player")
            
            -- Check if the unit is elite
            local isElite = npcClassification == "elite" or npcClassification == "rareelite" or npcClassification == "worldboss"
            
            -- Check if the unit's level is higher than the player's level or if the unit is elite
            if npcLevel >= playerLevel + 1 or isElite then
                local npcName = UnitName(unit)
                -- Display a raid warning and play a sound
                RaidNotice_AddMessage(RaidWarningFrame, (isElite and npcClassification.." " or "")..npcName.."("..npcLevel..") close", ChatTypeInfo["RAID_WARNING"])
                PlaySound(SOUNDKIT.RAID_WARNING)
                
                lastAlertTime = currentTime  -- Update the time of the last alert
            end
        end
    end
end)
