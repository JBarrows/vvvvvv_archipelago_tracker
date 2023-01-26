function trinketsUnlocked(codes)
    for i,v in ipairs(codes) do
        count = Tracker:ProviderCountForCode("trinket" .. v)
        if count < 1 then
            return false
        end
    end
    
    return true
end

function doorCost()
    return Tracker:ProviderCountForCode("doorCost")
end

function freeDoors()
    return doorCost() <= 0 
end

function getKeys(index)
    dc = doorCost()
    offset = (index * dc)
    keys = { }
    for i=1, dc do
        keys[i] = offset + i
    end
    return keys

end

function labUnlocked()
    if freeDoors() then
        return true
    end
    return trinketsUnlocked(getKeys(0))
end

function towerUnlocked()
    if freeDoors() then
        return true
    end
    return trinketsUnlocked(getKeys(1))
end

function spaceStationUnlocked()
    if freeDoors() then
        return true
    end
    return trinketsUnlocked(getKeys(2))
end

function warpZoneUnlocked()
    if freeDoors() then
        return true
    end
    return trinketsUnlocked(getKeys(3))
end

function trophyRoom()
    count = Tracker:ProviderCountForCode("trinket")
    return (count >= 10)
end

function finalLevel()
    return (labUnlocked() and towerUnlocked() and 
            spaceStationUnlocked() and warpZoneUnlocked())
end
