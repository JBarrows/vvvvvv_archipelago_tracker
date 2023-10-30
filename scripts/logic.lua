-- returns true if the key items mapped from the given list of numbers are all unlocked
-- eg. if codes = [1,2] then returns true if trinket 1 and trinket 2 are unlocked/active
function TrinketsUnlocked(codes)
    for _,v in ipairs(codes) do
        local count = Tracker:ProviderCountForCode("trinket" .. v)
        if count < 1 then
            return false
        end
    end
    
    return true
end

-- Returns the number of keys (count) needed to open any door
-- To get the exact numerical identifiers matched to a specific door, use GetKeys and TrinketsUnlocked
function DoorCost()
    return Tracker:ProviderCountForCode("doorCost")
end

-- Returns true if doors are always unlocked, as in the base game
function FreeDoors()
    return DoorCost() <= 0
end

-- Returns a list of numbers (1-12) that map to required keys for the given price index (0-4)
-- Ranges will be dependant on DoorCost.
-- In this case keys are shiny trinkets
function GetKeys(index)
    local dc = DoorCost()
    local offset = (index * dc)
    local keys = { }
    for i=1, dc do
        keys[i] = offset + i
    end
    return keys

end

-- Returns true if the region for a given index is accessible
function DestinationUnlocked(index)
    if FreeDoors() then return true end

    -- If areas are shuffled, find out which door leads to the target region (if any)
    -- Consider: "Door 1" might lead to "Room 3"
    local doorIndex = DoorIndexForDestination(index)
    if not doorIndex then return false end -- There may not be a destination assigned to this entrance
    
    -- If area costs are shuffled, we need find out which set of keys we're looking for
    -- Consider: "Key Ring 2" might be needed to unlock "Door 1"
    local priceIndex = PriceIndexForDoor(doorIndex)

    return TrinketsUnlocked(GetKeys(priceIndex))
end

function LabUnlocked()
    return DestinationUnlocked(REGION_INDEX_LABORATORY)
end

function TowerUnlocked()
    return DestinationUnlocked(REGION_INDEX_TOWER)
end

function SpaceStationUnlocked()
    return DestinationUnlocked(REGION_INDEX_STATION)
end

function WarpZoneUnlocked()
    return DestinationUnlocked(REGION_INDEX_WARP_ZONE)
end

-- Check whether the NPC trinket might be available
-- NOTE: This also requires one of two crew members to be rescued
function NPCTrinket()
    local count = Tracker:ProviderCountForCode("trinket")
    return (count >= 10)
end

-- One check in the final level is only available when all areas are complete
function FinalLevel()
    return (LabUnlocked() and TowerUnlocked() and
            SpaceStationUnlocked() and WarpZoneUnlocked())
end
