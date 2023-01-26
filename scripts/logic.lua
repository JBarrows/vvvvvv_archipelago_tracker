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

function labUnlocked()
    if freeDoors() then
        return true
    end
    return trinketsUnlocked({1,2,3})
end

function towerUnlocked()
    if freeDoors() then
        return true
    end
    return trinketsUnlocked({4,5,6})
end

function spaceStationUnlocked()
    if freeDoors() then
        return true
    end
    return trinketsUnlocked({7,8,9})
end

function warpZoneUnlocked()
    if freeDoors() then
        return true
    end
    return trinketsUnlocked({10,11,12})
end

function trophyRoom()
    count = Tracker:ProviderCountForCode("trinket")
    return (count >= 10)
end

function finalLevel()
    return (labUnlocked() and towerUnlocked() and 
            spaceStationUnlocked() and warpZoneUnlocked())
end
