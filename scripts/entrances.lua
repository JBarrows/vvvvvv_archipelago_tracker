REGION_INDEX_LABORATORY = 0
REGION_INDEX_TOWER = 1
REGION_INDEX_STATION = 2
REGION_INDEX_WARP_ZONE = 3

Entrances = {}

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

function Entrances:DoorIndexForDestination(regionIndex)
    for i, code in pairs(exitIds) do
        local exitItem = Tracker:FindObjectForCode(code)
        if exitItem and exitItem.CurrentStage == regionIndex then
            return i
        end
    end
    return nil
end

function Entrances:PriceIndexForDoor(doorIndex)
    local doorItem = Tracker:FindObjectForCode(doorIds[doorIndex])
    if doorItem then
        return doorItem.CurrentStage
    else
        return nil
    end
end

local function SetDoorOverlay(code)
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

function Entrances:UpdateDoorCosts(code)
    for _, doorCode in pairs(doorIds) do
        SetDoorOverlay(doorCode)
    end
end

function Entrances:Init()
    ScriptHost:AddWatchForCode("KeyCostChanged", "doorCost", Entrances.UpdateDoorCosts)
    
    for i = 0, 3 do
        local doorCode = doorIds[i]
        if doorCode then 
            ScriptHost:AddWatchForCode("PriceChanged_"..doorCode, doorCode, Entrances.UpdateDoorCosts)
        end
    end

    Entrances:UpdateDoorCosts("doorCost")
end
