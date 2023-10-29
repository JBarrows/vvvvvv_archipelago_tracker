function TrinketsUnlocked(codes)
    for i,v in ipairs(codes) do
        local count = Tracker:ProviderCountForCode("trinket" .. v)
        if count < 1 then
            return false
        end
    end
    
    return true
end

function DoorCost()
    return Tracker:ProviderCountForCode("doorCost")
end

function FreeDoors()
    return DoorCost() <= 0 
end

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

function NPCTrinket()
    local count = Tracker:ProviderCountForCode("trinket")
    return (count >= 10)
end

function FinalLevel()
    return (LabUnlocked() and TowerUnlocked() and 
            SpaceStationUnlocked() and WarpZoneUnlocked())
end
