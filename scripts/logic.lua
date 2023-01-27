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

function LabUnlocked()
    if FreeDoors() then
        return true
    end
    return TrinketsUnlocked(GetKeys(0))
end

function TowerUnlocked()
    if FreeDoors() then
        return true
    end
    return TrinketsUnlocked(GetKeys(1))
end

function SpaceStationUnlocked()
    if FreeDoors() then
        return true
    end
    return TrinketsUnlocked(GetKeys(2))
end

function WarpZoneUnlocked()
    if FreeDoors() then
        return true
    end
    return TrinketsUnlocked(GetKeys(3))
end

function NPCTrinket()
    local count = Tracker:ProviderCountForCode("trinket")
    return (count >= 10)
end

function FinalLevel()
    return (LabUnlocked() and TowerUnlocked() and 
            SpaceStationUnlocked() and WarpZoneUnlocked())
end
