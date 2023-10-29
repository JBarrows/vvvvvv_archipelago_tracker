REGION_INDEX_LABORATORY = 0
REGION_INDEX_TOWER = 1
REGION_INDEX_STATION = 2
REGION_INDEX_WARP_ZONE = 3

local doorIds = {
    [0] = "doorLabEntrance",
    [1] = "doorTowerEntrance",
    [2] = "doorStationEntrance",
    [3] = "doorWarpEntrance",
}

local exitIds = {
    [0] = "doorLabExit",
    [1] = "doorTowerExit",
    [2] = "doorStationExit",
    [3] = "doorWarpExit",
}

function DoorIndexForDestination(regionIndex)
    for i, code in pairs(exitIds) do
        local exitItem = Tracker:FindObjectForCode(code)
        if exitItem and exitItem.CurrentStage == regionIndex then
            return i
        end
    end
    return nil
end

function PriceIndexForDoor(doorIndex)
    local doorItem = Tracker:FindObjectForCode(doorIds[doorIndex])
    if doorItem then
        return doorItem.CurrentStage
    else
        return nil
    end
end

function SetDoorOverlay(code)
    -- Would be nice to hold a table of the items
    local doorItem = Tracker:FindObjectForCode(code)
    if not doorItem then return end

    local dc = Tracker:ProviderCountForCode("doorCost")
    if dc == 0 then
        doorItem:SetOverlay("")
    else
        local lower = dc * doorItem.CurrentStage + 1
        local upper = lower + (dc - 1)
        doorItem:SetOverlay(lower.."-"..upper)
    end
end

function UpdateDoorCosts(code)
    for _, doorCode in pairs(doorIds) do
        SetDoorOverlay(doorCode)
    end
end

ScriptHost:AddWatchForCode("KeyCostChanged", "doorCost", UpdateDoorCosts)
ScriptHost:AddWatchForCode("DoorPriceChangedLab", "doorLabEntrance", UpdateDoorCosts)
ScriptHost:AddWatchForCode("DoorPriceChangedTower", "doorTowerEntrance", UpdateDoorCosts)
ScriptHost:AddWatchForCode("DoorPriceChangedStation", "doorStationEntrance", UpdateDoorCosts)
ScriptHost:AddWatchForCode("DoorPriceChangedWarpZone", "doorWarpEntrance", UpdateDoorCosts)